import { randomUUID } from 'node:crypto';
import { formatQuantity, toMilli } from '../../src/common/quantity/quantity.js';
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
  MaterialRequestOutcome,
  StockPlace,
} from '../../src/generated/prisma/enums.js';
import {
  requestApproved,
  requestClosed,
  requestCreated,
  requestRejected,
  requestToSend,
  stockLow,
  stockSent,
} from '../../src/notifications/notification-messages.js';
import { requestCode } from '../../src/stock/request-progress.js';

// Development stock: two godowns, each with a manager, and three weeks of
// material requests, buying, sending, using and returning. Every balance stays
// at or above zero. TMT steel ends below its minimum. One request waits for
// approval, one is part sent (its delivery to ABC is on the way), one was
// rejected and two were closed with leftovers returned (one return is still
// on its way to the Main godown). Seeded entries have no photos.

const GODOWNS = [
  {
    key: 'main',
    name: 'Main godown',
    address: '14, SIDCO Industrial Estate, Ambattur, Chennai 600098',
    managerKey: 'selvam',
  },
  {
    key: 'porur',
    name: 'Porur godown',
    address: '7, Mount Poonamallee Road, Porur, Chennai 600116',
    managerKey: 'karthik',
  },
];

interface MaterialSeed {
  key: string;
  name: string;
  unit: string;
  category: string;
  minStock?: number;
  isActive?: boolean;
}

const MATERIALS: MaterialSeed[] = [
  {
    key: 'cement',
    name: 'Cement OPC 53',
    unit: 'bag',
    category: 'Cement',
    minStock: 150,
  },
  {
    key: 'steel',
    name: 'TMT Steel 12mm',
    unit: 'kg',
    category: 'Steel',
    minStock: 2000,
  },
  {
    key: 'sand',
    name: 'M-Sand',
    unit: 'cft',
    category: 'Sand & aggregates',
    minStock: 500,
  },
  {
    key: 'metal',
    name: 'Blue metal 20mm',
    unit: 'cft',
    category: 'Sand & aggregates',
    minStock: 300,
  },
  {
    key: 'bricks',
    name: 'Red bricks',
    unit: 'nos',
    category: 'Bricks & blocks',
    minStock: 5000,
  },
  { key: 'putty', name: 'Wall putty', unit: 'bag', category: 'Finishing' },
  {
    key: 'flyash',
    name: 'Fly ash bricks',
    unit: 'nos',
    category: 'Bricks & blocks',
    isActive: false,
  },
];

interface RequestSeed {
  key: string;
  site: string;
  by: string;
  daysAgo: number;
  time: string;
  /** Days after the request day. */
  neededInDays?: number;
  note?: string;
  /** [material, asked, approved when it differs] */
  lines: [string, number, number?][];
  approved?: { daysAgo: number; time: string; godown: string; note?: string };
  rejected?: { daysAgo: number; time: string; reason: string };
  closed?: {
    daysAgo: number;
    time: string;
    by: string;
    outcome: MaterialRequestOutcome;
    note?: string;
  };
}

/** In the order they were made, so they number MR-0001 onwards. */
const REQUESTS: RequestSeed[] = [
  {
    key: 'gv-1',
    site: 'greenvalley',
    by: 'prakash',
    daysAgo: 19,
    time: '10:30',
    note: 'Mortar and plastering for the ground floor.',
    lines: [
      ['cement', 100],
      ['sand', 800],
    ],
    approved: { daysAgo: 19, time: '12:00', godown: 'porur' },
  },
  {
    key: 'gv-2',
    site: 'greenvalley',
    by: 'prakash',
    daysAgo: 19,
    time: '10:45',
    note: 'Compound wall and ground floor walls.',
    lines: [['bricks', 8000]],
    approved: { daysAgo: 19, time: '12:05', godown: 'main' },
    closed: {
      daysAgo: 1,
      time: '15:30',
      by: 'prakash',
      outcome: 'LEFTOVER_RETURNED',
      note: 'Compound wall done; 1,000 bricks not needed here.',
    },
  },
  {
    key: 'abc-1',
    site: 'abc',
    by: 'arun',
    daysAgo: 19,
    time: '11:00',
    note: 'First floor columns and slab.',
    lines: [
      ['cement', 150],
      ['steel', 2000],
      ['sand', 1000],
      ['metal', 600],
      ['bricks', 10000],
    ],
    approved: { daysAgo: 19, time: '12:10', godown: 'main' },
  },
  {
    key: 'sl-1',
    site: 'srilakshmi',
    by: 'suresh',
    daysAgo: 17,
    time: '10:00',
    note: 'Ground floor columns.',
    lines: [
      ['cement', 80],
      ['steel', 1500],
      ['metal', 600, 500],
    ],
    approved: {
      daysAgo: 17,
      time: '11:30',
      godown: 'main',
      note: 'Only 500 cft of blue metal for now.',
    },
    closed: {
      daysAgo: 6,
      time: '16:00',
      by: 'suresh',
      outcome: 'LEFTOVER_RETURNED',
      note: 'Column work done; extra blue metal back to the godown.',
    },
  },
  {
    key: 'gv-3',
    site: 'greenvalley',
    by: 'prakash',
    daysAgo: 8,
    time: '11:00',
    lines: [['putty', 20]],
    rejected: {
      daysAgo: 7,
      time: '10:00',
      reason: 'Painting starts next month. Ask again then.',
    },
  },
  {
    key: 'abc-2',
    site: 'abc',
    by: 'arun',
    daysAgo: 2,
    time: '10:00',
    neededInDays: 2,
    note: 'Second floor slab.',
    lines: [
      ['cement', 100],
      ['sand', 300],
    ],
    approved: { daysAgo: 2, time: '13:00', godown: 'main' },
  },
  {
    key: 'sl-2',
    site: 'srilakshmi',
    by: 'suresh',
    daysAgo: 1,
    time: '17:00',
    neededInDays: 3,
    note: 'First floor columns.',
    lines: [
      ['steel', 1000],
      ['cement', 40],
    ],
  },
];

/** "godown:main", "site:abc", or one of the outside places. */
type Where =
  | `godown:${string}`
  | `site:${string}`
  | 'supplier'
  | 'used'
  | 'waste'
  | 'count';

interface FormSeed {
  daysAgo: number;
  time: string;
  from: Where;
  to: Where;
  by: string;
  /** [material, quantity, price per unit for purchases] */
  lines: [string, number, number?][];
  supplier?: string;
  billNo?: string;
  dcNumber?: string;
  note?: string;
  /** Deliveries against a request, and leftovers returned when it closed. */
  request?: string;
  /** Moves between godowns and sites: when it was confirmed, or not yet. */
  received?:
    | 'pending'
    | {
        daysAgo: number;
        time: string;
        by: string;
        short?: { material: string; quantity: number; note: string };
      };
}

const FORMS: FormSeed[] = [
  {
    daysAgo: 20,
    time: '11:00',
    from: 'supplier',
    to: 'godown:main',
    by: 'admin',
    supplier: 'Sri Balaji Traders',
    billNo: 'SBT/2026/0412',
    lines: [
      ['cement', 300, 380],
      ['steel', 5000, 68],
      ['sand', 3000, 52],
      ['metal', 1500, 46],
      ['bricks', 30000, 9.5],
      ['putty', 50, 720],
    ],
  },
  {
    daysAgo: 19,
    time: '09:30',
    from: 'supplier',
    to: 'godown:porur',
    by: 'admin',
    supplier: 'Sri Murugan Sand Supply',
    billNo: 'SMS-2291',
    lines: [
      ['cement', 100, 395],
      ['sand', 800, 54],
    ],
  },
  {
    daysAgo: 18,
    time: '09:30',
    from: 'godown:main',
    to: 'site:abc',
    by: 'selvam',
    request: 'abc-1',
    dcNumber: 'DC-0101',
    lines: [
      ['cement', 150],
      ['steel', 2000],
      ['sand', 1000],
      ['metal', 600],
      ['bricks', 10000],
    ],
    received: {
      daysAgo: 17,
      time: '15:00',
      by: 'arun',
      short: { material: 'cement', quantity: 148, note: 'Two bags torn.' },
    },
  },
  {
    daysAgo: 18,
    time: '10:00',
    from: 'godown:porur',
    to: 'site:greenvalley',
    by: 'karthik',
    request: 'gv-1',
    dcNumber: 'DC-0102',
    lines: [
      ['cement', 100],
      ['sand', 800],
    ],
    received: { daysAgo: 18, time: '16:30', by: 'prakash' },
  },
  {
    daysAgo: 18,
    time: '10:15',
    from: 'godown:main',
    to: 'site:greenvalley',
    by: 'selvam',
    request: 'gv-2',
    dcNumber: 'DC-0103',
    lines: [['bricks', 8000]],
    received: { daysAgo: 18, time: '17:00', by: 'prakash' },
  },
  {
    daysAgo: 16,
    time: '10:30',
    from: 'godown:main',
    to: 'site:srilakshmi',
    by: 'selvam',
    request: 'sl-1',
    dcNumber: 'DC-0104',
    lines: [
      ['cement', 80],
      ['steel', 1500],
      ['metal', 500],
    ],
    received: { daysAgo: 16, time: '17:00', by: 'suresh' },
  },
  {
    daysAgo: 12,
    time: '11:30',
    from: 'supplier',
    to: 'godown:porur',
    by: 'karthik',
    supplier: 'Porur Building Materials',
    billNo: 'PBM-1187',
    lines: [
      ['cement', 120, 390],
      ['sand', 600, 53],
    ],
  },
  {
    daysAgo: 10,
    time: '12:00',
    from: 'supplier',
    to: 'godown:main',
    by: 'selvam',
    supplier: 'Ramco Cements',
    billNo: 'RC-88412',
    lines: [['cement', 200, 395]],
  },
  {
    daysAgo: 9,
    time: '18:00',
    from: 'site:greenvalley',
    to: 'waste',
    by: 'prakash',
    note: 'Set hard after rain got into the shed.',
    lines: [['cement', 3]],
  },
  {
    daysAgo: 6,
    time: '16:00',
    from: 'site:srilakshmi',
    to: 'godown:main',
    by: 'suresh',
    request: 'sl-1',
    lines: [['metal', 100]],
    received: { daysAgo: 5, time: '11:00', by: 'selvam' },
  },
  {
    daysAgo: 3,
    time: '17:30',
    from: 'godown:main',
    to: 'count',
    by: 'selvam',
    note: 'Monthly count: two bags missing.',
    lines: [['putty', 2]],
  },
  {
    daysAgo: 1,
    time: '10:00',
    from: 'godown:main',
    to: 'site:abc',
    by: 'selvam',
    request: 'abc-2',
    dcNumber: 'DC-0109',
    lines: [
      ['cement', 50],
      ['sand', 300],
    ],
    received: 'pending',
  },
  {
    daysAgo: 1,
    time: '15:30',
    from: 'site:greenvalley',
    to: 'godown:main',
    by: 'prakash',
    request: 'gv-2',
    lines: [['bricks', 1000]],
    received: 'pending',
  },
];

/** Typical use per working day; seven days are recorded at each site. */
const DAILY_USE: Record<
  string,
  { by: string[]; note: string; lines: [string, number][] }
> = {
  abc: {
    by: ['arun', 'ravi'],
    note: 'First floor columns and slab.',
    lines: [
      ['cement', 8],
      ['steel', 150],
      ['sand', 60],
      ['metal', 40],
      ['bricks', 900],
    ],
  },
  greenvalley: {
    by: ['prakash', 'manoj'],
    note: 'Brickwork and plastering.',
    lines: [
      ['cement', 6],
      ['sand', 50],
      ['bricks', 700],
    ],
  },
  srilakshmi: {
    by: ['suresh', 'vijay'],
    note: 'Ground floor columns.',
    lines: [
      ['cement', 5],
      ['steel', 120],
      ['metal', 35],
    ],
  },
};
/** Seven days around the daily figure (rounded to whole units). */
const USE_PATTERN = [1, 1.25, 0.75, 1, 1.25, 0.75, 1];

export interface StockSeedInput {
  today: string;
  timeZone: string;
  isWorkingDay: (date: string) => boolean;
  userId: (key: string) => string;
  userName: (key: string) => string;
  site: (key: string) => {
    id: string;
    name: string;
    engineerIds: string[];
  };
  adminIds: string[];
}

export async function seedStock(
  prisma: PrismaClient,
  input: StockSeedInput,
): Promise<{
  godowns: number;
  materials: number;
  materialRequests: number;
  stockEntries: number;
  notifications: Prisma.NotificationCreateManyInput[];
}> {
  const { today, timeZone } = input;
  const day = (daysAgo: number) => addDays(today, -daysAgo);
  const at = (daysAgo: number, time: string) =>
    zonedInstant(day(daysAgo), time, timeZone);
  const adminId = input.adminIds[0];

  const godowns = new Map<
    string,
    { id: string; name: string; managerIds: string[] }
  >();
  for (const g of GODOWNS) {
    const managerId = input.userId(g.managerKey);
    const created = await prisma.godown.create({
      data: {
        name: g.name,
        address: g.address,
        createdAt: at(30, '09:00'),
        managers: {
          create: {
            userId: managerId,
            assignedAt: at(30, '09:30'),
            assignedById: adminId,
          },
        },
      },
    });
    godowns.set(g.key, { ...created, managerIds: [managerId] });
  }
  const godown = (key: string) => godowns.get(key)!;
  const materials = new Map<
    string,
    { id: string; name: string; unit: string }
  >();
  for (const m of MATERIALS) {
    materials.set(
      m.key,
      await prisma.material.create({
        data: {
          name: m.name,
          unit: m.unit,
          category: m.category,
          minStock: m.minStock ?? null,
          isActive: m.isActive ?? true,
          createdAt: at(30, '10:00'),
        },
      }),
    );
  }
  const material = (key: string) => materials.get(key)!;
  const items = (lines: [string, number, number?][]) =>
    lines.map(
      ([key, quantity]) =>
        `${material(key).name}: ${formatQuantity(toMilli(quantity), material(key).unit)}`,
    );

  const notifications: Prisma.NotificationCreateManyInput[] = [];
  const notify = (
    recipientIds: readonly string[],
    text: { title: string; message: string },
    createdAt: Date,
    reference: Pick<
      Prisma.NotificationCreateManyInput,
      'referenceType' | 'referenceId' | 'data' | 'dedupeKey'
    >,
    isRead = false,
  ) => {
    for (const recipientId of new Set(recipientIds))
      notifications.push({
        recipientId,
        type: 'STOCK',
        ...text,
        ...reference,
        isRead,
        pushStatus: 'SENT',
        pushSentAt: createdAt,
        createdAt,
      });
  };

  // Requests: asked, then approved or rejected, and closed when done.
  const requests = new Map<string, { id: string; code: string }>();
  for (const r of REQUESTS) {
    const site = input.site(r.site);
    const by = input.userId(r.by);
    const createdAt = at(r.daysAgo, r.time);
    const review = r.approved ?? r.rejected;
    const row = await prisma.materialRequest.create({
      data: {
        requestId: randomUUID(),
        siteId: site.id,
        requestedById: by,
        neededBy:
          r.neededInDays === undefined
            ? null
            : toDbDate(addDays(day(r.daysAgo), r.neededInDays)),
        note: r.note ?? null,
        status: r.closed
          ? 'CLOSED'
          : r.approved
            ? 'APPROVED'
            : r.rejected
              ? 'REJECTED'
              : 'PENDING',
        godownId: r.approved ? godown(r.approved.godown).id : null,
        ...(review && {
          reviewedById: adminId,
          reviewedAt: at(review.daysAgo, review.time),
        }),
        reviewNote: r.approved?.note ?? r.rejected?.reason ?? null,
        ...(r.closed && {
          outcome: r.closed.outcome,
          closedById: input.userId(r.closed.by),
          closedAt: at(r.closed.daysAgo, r.closed.time),
          closeNote: r.closed.note ?? null,
        }),
        createdAt,
        lines: {
          create: r.lines.map(([key, asked, approved]) => ({
            materialId: material(key).id,
            quantity: asked,
            approvedQuantity: r.approved ? (approved ?? asked) : null,
          })),
        },
      },
    });
    const code = requestCode(row.number);
    requests.set(r.key, { id: row.id, code });
    const reference = (dedupeKey: string) => ({
      referenceType: 'MATERIAL_REQUEST' as const,
      referenceId: row.id,
      data: { requestId: row.id, siteId: site.id },
      dedupeKey: `${dedupeKey}:${row.id}`,
    });
    const done = Boolean(r.approved || r.rejected);
    notify(
      input.adminIds,
      requestCreated({
        code,
        siteName: site.name,
        byName: input.userName(r.by),
        items: items(r.lines),
      }),
      createdAt,
      reference('request'),
      done,
    );
    const siteTeam = [by, ...site.engineerIds];
    if (r.approved) {
      const from = godown(r.approved.godown);
      const reviewedAt = at(r.approved.daysAgo, r.approved.time);
      notify(
        siteTeam,
        requestApproved({ code, godownName: from.name }),
        reviewedAt,
        reference('request-approved'),
        r.daysAgo > 2,
      );
      notify(
        from.managerIds,
        requestToSend({
          code,
          siteName: site.name,
          items: items(
            r.lines.map(([key, asked, approved]) => [key, approved ?? asked]),
          ),
        }),
        reviewedAt,
        reference('request-to-send'),
        r.daysAgo > 2,
      );
    }
    if (r.rejected) {
      notify(
        siteTeam,
        requestRejected({ code, reason: r.rejected.reason }),
        at(r.rejected.daysAgo, r.rejected.time),
        reference('request-rejected'),
        true,
      );
    }
    if (r.closed && r.approved) {
      notify(
        [...input.adminIds, ...godown(r.approved.godown).managerIds],
        requestClosed({
          code,
          siteName: site.name,
          leftover: r.closed.outcome === 'LEFTOVER_RETURNED',
        }),
        at(r.closed.daysAgo, r.closed.time),
        reference('request-closed'),
        r.closed.daysAgo > 2,
      );
    }
  }

  const usage: FormSeed[] = [];
  const workdays = Array.from({ length: 14 }, (_, i) => i + 1)
    .filter((daysAgo) => input.isWorkingDay(day(daysAgo)))
    .slice(0, USE_PATTERN.length);
  for (const [siteKey, use] of Object.entries(DAILY_USE)) {
    workdays.forEach((daysAgo, index) =>
      usage.push({
        daysAgo,
        time: '18:15',
        from: `site:${siteKey}`,
        to: 'used',
        by: use.by[index % use.by.length],
        note: use.note,
        lines: use.lines.map(([key, perDay]) => [
          key,
          Math.round(perDay * USE_PATTERN[index]),
        ]),
      }),
    );
  }

  const place = (where: Where) => {
    if (where.startsWith('site:')) {
      const site = input.site(where.slice(5));
      return {
        place: 'SITE' as StockPlace,
        godownId: null,
        siteId: site.id,
        name: site.name,
        receiverIds: site.engineerIds,
      };
    }
    if (where.startsWith('godown:')) {
      const g = godown(where.slice(7));
      return {
        place: 'GODOWN' as StockPlace,
        godownId: g.id,
        siteId: null,
        name: g.name,
        receiverIds: g.managerIds.length ? g.managerIds : input.adminIds,
      };
    }
    const places: Record<string, StockPlace> = {
      supplier: 'SUPPLIER',
      used: 'USED',
      waste: 'WASTE',
      count: 'ADJUSTMENT',
    };
    return {
      place: places[where],
      godownId: null,
      siteId: null,
      name: '',
      receiverIds: [],
    };
  };

  let entries = 0;
  for (const form of [...FORMS, ...usage]) {
    const from = place(form.from);
    const to = place(form.to);
    const createdAt = at(form.daysAgo, form.time);
    const movedOn = toDbDate(day(form.daysAgo));
    const received = form.received;
    const pending = received === 'pending';
    const receivedOn = pending
      ? null
      : toDbDate(day(received?.daysAgo ?? form.daysAgo));
    const request = form.request ? requests.get(form.request)! : null;
    // A request's leftover goes back to its godown when it closes.
    const note =
      request && from.place === 'SITE'
        ? `Leftover from ${request.code}`
        : (form.note ?? null);
    const columns = {
      fromPlace: from.place,
      fromGodownId: from.godownId,
      fromSiteId: from.siteId,
      toPlace: to.place,
      toGodownId: to.godownId,
      toSiteId: to.siteId,
      status: pending ? ('IN_TRANSIT' as const) : ('DONE' as const),
      movedOn,
      receivedOn,
    };
    const entry = await prisma.stockEntry.create({
      data: {
        requestId: randomUUID(),
        ...columns,
        dcNumber: form.dcNumber ?? null,
        supplier: form.supplier ?? null,
        billNo: form.billNo ?? null,
        note,
        materialRequestId: request?.id ?? null,
        createdById: input.userId(form.by),
        createdAt,
        ...(received &&
          received !== 'pending' && {
            receivedAt: at(received.daysAgo, received.time),
            receivedById: input.userId(received.by),
            receiveNote: received.short?.note ?? null,
          }),
        lines: {
          create: form.lines.map(([key, quantity, rate]) => ({
            materialId: material(key).id,
            quantity,
            rate: rate ?? null,
            ...columns,
            receivedQuantity: pending
              ? null
              : received?.short?.material === key
                ? received.short.quantity
                : quantity,
          })),
        },
      },
    });
    entries += 1;
    if (pending) {
      notify(
        to.receiverIds.filter((id) => id !== input.userId(form.by)),
        stockSent({
          toName: to.name,
          fromName: from.name,
          byName: input.userName(form.by),
          items: items(form.lines),
        }),
        createdAt,
        {
          referenceType: 'STOCK_ENTRY',
          referenceId: entry.id,
          data: {
            to: to.place,
            ...((to.siteId ?? from.siteId) && {
              siteId: (to.siteId ?? from.siteId)!,
            }),
            ...((to.godownId ?? from.godownId) && {
              godownId: (to.godownId ?? from.godownId)!,
            }),
          },
          dedupeKey: `stock:${entry.id}`,
        },
      );
    }
  }

  // Steel crossed its minimum when the second delivery left the Main godown.
  const steel = material('steel');
  notify(
    input.adminIds,
    stockLow({
      material: steel.name,
      left: formatQuantity(toMilli(1500), steel.unit),
      minimum: formatQuantity(toMilli(2000), steel.unit),
    }),
    at(16, '10:30'),
    {
      data: { materialId: steel.id },
      dedupeKey: `stock-low:${steel.id}:seed`,
    },
    true,
  );

  return {
    godowns: godowns.size,
    materials: materials.size,
    materialRequests: requests.size,
    stockEntries: entries,
    notifications,
  };
}
