import { randomUUID } from 'node:crypto';
import { fromPaise, toPaise } from '../../src/common/money/money.js';
import {
  addDays,
  toDbDate,
  zonedInstant,
} from '../../src/common/time/business-time.js';
import type {
  Prisma,
  PrismaClient,
} from '../../src/generated/prisma/client.js';
import type {
  ApprovalStatus,
  VehicleType,
} from '../../src/generated/prisma/enums.js';
import {
  repairMoneyDecided,
  repairMoneyRequested,
  vehicleGiven,
} from '../../src/notifications/notification-messages.js';
import {
  repairCode,
  vehicleCode,
  vehicleLabel,
} from '../../src/vehicles/vehicle-common.js';

export interface VehiclesSeedInput {
  today: string;
  timeZone: string;
  userId: (key: string) => string;
  userName: (key: string) => string;
  adminId: string;
  adminName: string;
}

interface HandoverSeed {
  userKey: string;
  givenDaysAgo: number;
  /** Missing: they still have it. */
  returnedDaysAgo?: number;
  note?: string;
  returnNote?: string;
}

interface VehicleSeed {
  key: string;
  type: VehicleType;
  registrationNo: string;
  makeModel: string;
  note?: string;
  isActive?: boolean;
  /** Oldest first. */
  handovers: HandoverSeed[];
}

/** Given out, free with a past holder, never given, and out of use. */
const VEHICLES: VehicleSeed[] = [
  {
    key: 'splendor',
    type: 'BIKE',
    registrationNo: 'TN09BK4821',
    makeModel: 'Hero Splendor Plus',
    handovers: [
      {
        userKey: 'manoj',
        givenDaysAgo: 120,
        returnedDaysAgo: 46,
        note: 'With helmet and tool kit',
        returnNote: 'Moved to the Villa site, close to home',
      },
      { userKey: 'ravi', givenDaysAgo: 45, note: 'With helmet and tool kit' },
    ],
  },
  {
    key: 'shine',
    type: 'BIKE',
    registrationNo: 'TN10CQ7730',
    makeModel: 'Honda Shine 125',
    note: 'Insurance renewed in June',
    handovers: [{ userKey: 'arun', givenDaysAgo: 200 }],
  },
  {
    key: 'activa',
    type: 'SCOOTER',
    registrationNo: 'TN09AZ1164',
    makeModel: 'Honda Activa 6G',
    handovers: [{ userKey: 'kumar', givenDaysAgo: 20 }],
  },
  {
    key: 'xl',
    type: 'BIKE',
    registrationNo: 'TN22DE0915',
    makeModel: 'TVS XL100',
    handovers: [],
  },
  {
    key: 'bolero',
    type: 'VAN',
    registrationNo: 'TN09T5502',
    makeModel: 'Mahindra Bolero Pickup',
    note: 'Sold in August',
    isActive: false,
    handovers: [],
  },
];

interface RepairSeed {
  vehicleKey: string;
  userKey: string;
  amount: string;
  note: string;
  askedDaysAgo: number;
  askedAt: string;
  status: ApprovalStatus;
  decision?: { daysAgo: number; time: string; note?: string };
}

/** Waiting, approved, rejected and withdrawn. */
const REPAIRS: RepairSeed[] = [
  {
    vehicleKey: 'splendor',
    userKey: 'ravi',
    amount: '850',
    note: 'Rear tyre puncture and a new tube',
    askedDaysAgo: 0,
    askedAt: '08:40',
    status: 'PENDING',
  },
  {
    vehicleKey: 'shine',
    userKey: 'arun',
    amount: '2400',
    note: 'Chain and sprocket set is worn out',
    askedDaysAgo: 1,
    askedAt: '19:10',
    status: 'PENDING',
  },
  {
    vehicleKey: 'splendor',
    userKey: 'ravi',
    amount: '1200',
    note: 'General service and engine oil change',
    askedDaysAgo: 12,
    askedAt: '09:05',
    status: 'APPROVED',
    decision: {
      daysAgo: 12,
      time: '11:30',
      note: 'Use the Hero service centre on the main road.',
    },
  },
  {
    vehicleKey: 'activa',
    userKey: 'kumar',
    amount: '6500',
    note: 'New seat cover, mirrors and body polish',
    askedDaysAgo: 6,
    askedAt: '13:20',
    status: 'REJECTED',
    decision: {
      daysAgo: 5,
      time: '10:15',
      note: 'Not needed now. Ask again for the mirrors alone.',
    },
  },
  {
    vehicleKey: 'shine',
    userKey: 'arun',
    amount: '300',
    note: 'Brake cable adjustment',
    askedDaysAgo: 9,
    askedAt: '17:00',
    status: 'CANCELLED',
  },
];

/** Company vehicles, who holds them, repair money asked for, and the alerts raised. */
export async function seedVehicles(
  prisma: PrismaClient,
  input: VehiclesSeedInput,
): Promise<{
  vehicles: number;
  vehicleRepairRequests: number;
  notifications: Prisma.NotificationCreateManyInput[];
}> {
  const { today, timeZone, adminId, adminName } = input;
  const at = (daysAgo: number, time: string) =>
    zonedInstant(addDays(today, -daysAgo), time, timeZone);
  const notifications: Prisma.NotificationCreateManyInput[] = [];
  const vehicles = new Map<
    string,
    { id: string; code: string; label: string }
  >();

  for (const seed of VEHICLES) {
    const row = await prisma.vehicle.create({
      data: {
        type: seed.type,
        registrationNo: seed.registrationNo,
        makeModel: seed.makeModel,
        note: seed.note ?? null,
        isActive: seed.isActive ?? true,
        createdById: adminId,
        createdAt: at(220, '10:00'),
      },
    });
    const code = vehicleCode(row.number);
    const label = vehicleLabel(seed);
    vehicles.set(seed.key, { id: row.id, code, label });
    for (const handover of seed.handovers) {
      const returned = handover.returnedDaysAgo !== undefined;
      const assignment = await prisma.vehicleAssignment.create({
        data: {
          vehicleId: row.id,
          userId: input.userId(handover.userKey),
          givenOn: toDbDate(addDays(today, -handover.givenDaysAgo)),
          returnedOn: returned
            ? toDbDate(addDays(today, -handover.returnedDaysAgo!))
            : null,
          note: handover.note ?? null,
          returnNote: handover.returnNote ?? null,
          givenById: adminId,
          returnedById: returned ? adminId : null,
          createdAt: at(handover.givenDaysAgo, '10:30'),
        },
      });
      if (returned) continue;
      notifications.push({
        recipientId: input.userId(handover.userKey),
        type: 'VEHICLE',
        ...vehicleGiven({ code, label, byName: adminName }),
        referenceType: 'VEHICLE',
        referenceId: row.id,
        data: { vehicleId: row.id },
        dedupeKey: `vehicle-given:${assignment.id}`,
        isRead: true,
        createdAt: at(handover.givenDaysAgo, '10:30'),
      });
    }
  }

  for (const seed of REPAIRS) {
    const vehicle = vehicles.get(seed.vehicleKey);
    if (!vehicle) throw new Error(`Unknown seed vehicle ${seed.vehicleKey}`);
    const userId = input.userId(seed.userKey);
    const amount = toPaise(seed.amount);
    const askedAt = at(seed.askedDaysAgo, seed.askedAt);
    const decidedAt = seed.decision
      ? at(seed.decision.daysAgo, seed.decision.time)
      : null;
    const row = await prisma.vehicleRepairRequest.create({
      data: {
        requestId: randomUUID(),
        vehicleId: vehicle.id,
        userId,
        amount: fromPaise(amount),
        note: seed.note,
        status: seed.status,
        reviewedById: seed.decision ? adminId : null,
        reviewedAt: decidedAt,
        reviewNote: seed.decision?.note ?? null,
        createdAt: askedAt,
      },
    });
    const code = repairCode(row.number);
    notifications.push({
      recipientId: adminId,
      type: 'VEHICLE',
      ...repairMoneyRequested({
        code,
        name: input.userName(seed.userKey),
        amount,
        label: vehicle.label,
      }),
      referenceType: 'VEHICLE_REPAIR_REQUEST',
      referenceId: row.id,
      data: { repairRequestId: row.id, vehicleId: vehicle.id },
      dedupeKey: `vehicle-repair:${row.id}`,
      // Only the waiting ones are still unread.
      isRead: seed.status !== 'PENDING',
      createdAt: askedAt,
    });
    if (seed.decision && decidedAt) {
      notifications.push({
        recipientId: userId,
        type: 'VEHICLE',
        ...repairMoneyDecided({
          code,
          amount,
          approved: seed.status === 'APPROVED',
          byName: adminName,
          note: seed.decision.note ?? null,
        }),
        referenceType: 'VEHICLE_REPAIR_REQUEST',
        referenceId: row.id,
        data: { repairRequestId: row.id, vehicleId: vehicle.id },
        dedupeKey: `vehicle-repair-decided:${row.id}`,
        createdAt: decidedAt,
      });
    }
  }

  return {
    vehicles: VEHICLES.length,
    vehicleRepairRequests: REPAIRS.length,
    notifications,
  };
}
