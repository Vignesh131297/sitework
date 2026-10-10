import type {
  Designation,
  EngineerUpdateType,
  IssueStatus,
  PaymentMethod,
  Priority,
  Role,
} from '../../src/generated/prisma/enums.js';
import type { StaffHabits } from './field-activity.js';

// Development data only. Phone numbers and e-mail domains (.test) are fictional.

export const DEV_PASSWORDS: Record<Role, string> = {
  ADMIN: 'Admin@123',
  ENGINEER: 'Engineer@123',
  STAFF: 'Staff@123',
  GODOWN_MANAGER: 'Godown@123',
};

export interface PersonSeed {
  key: string;
  role: Role;
  name: string;
  phone: string;
  email?: string;
  employeeCode: string;
  designation?: Designation;
  joinedDaysAgo: number;
}

export const PEOPLE: PersonSeed[] = [
  {
    key: 'admin',
    role: 'ADMIN',
    name: 'Admin User',
    phone: '+919000000001',
    email: 'admin@sitework.test',
    employeeCode: 'ADM-001',
    joinedDaysAgo: 900,
  },
  {
    key: 'arun',
    role: 'ENGINEER',
    name: 'Arun Kumar',
    phone: '+919000000011',
    email: 'arun@sitework.test',
    employeeCode: 'ENG-001',
    joinedDaysAgo: 720,
  },
  {
    key: 'prakash',
    role: 'ENGINEER',
    name: 'Prakash',
    phone: '+919000000012',
    email: 'prakash@sitework.test',
    employeeCode: 'ENG-002',
    joinedDaysAgo: 540,
  },
  {
    key: 'suresh',
    role: 'ENGINEER',
    name: 'Suresh',
    phone: '+919000000013',
    email: 'suresh@sitework.test',
    employeeCode: 'ENG-003',
    joinedDaysAgo: 400,
  },
  {
    key: 'ravi',
    role: 'STAFF',
    name: 'Ravi',
    phone: '+919000000101',
    employeeCode: 'STF-001',
    designation: 'MASON',
    joinedDaysAgo: 610,
  },
  {
    key: 'kumar',
    role: 'STAFF',
    name: 'Kumar',
    phone: '+919000000102',
    employeeCode: 'STF-002',
    designation: 'HELPER',
    joinedDaysAgo: 300,
  },
  {
    key: 'manoj',
    role: 'STAFF',
    name: 'Manoj',
    phone: '+919000000103',
    employeeCode: 'STF-003',
    designation: 'ELECTRICIAN',
    joinedDaysAgo: 450,
  },
  {
    key: 'sathish',
    role: 'STAFF',
    name: 'Sathish',
    phone: '+919000000104',
    employeeCode: 'STF-004',
    designation: 'CARPENTER',
    joinedDaysAgo: 380,
  },
  {
    key: 'vijay',
    role: 'STAFF',
    name: 'Vijay',
    phone: '+919000000105',
    employeeCode: 'STF-005',
    designation: 'PLUMBER',
    joinedDaysAgo: 260,
  },
  {
    key: 'muthu',
    role: 'STAFF',
    name: 'Muthu',
    phone: '+919000000106',
    employeeCode: 'STF-006',
    designation: 'PAINTER',
    joinedDaysAgo: 200,
  },
  {
    key: 'selvam',
    role: 'GODOWN_MANAGER',
    name: 'Selvam',
    phone: '+919000000201',
    employeeCode: 'GDM-001',
    joinedDaysAgo: 500,
  },
  {
    key: 'karthik',
    role: 'GODOWN_MANAGER',
    name: 'Karthik',
    phone: '+919000000202',
    employeeCode: 'GDM-002',
    joinedDaysAgo: 320,
  },
];

export interface ClientSeed {
  key: string;
  name: string;
  company: string;
  phone: string;
  email: string;
  address: string;
  notes?: string;
}

export const CLIENTS: ClientSeed[] = [
  {
    key: 'abc',
    name: 'ABC Constructions',
    company: 'ABC Constructions Pvt. Ltd.',
    phone: '+919000001001',
    email: 'accounts@abcconstructions.test',
    address: 'No. 45, 2nd Avenue, Anna Nagar, Chennai 600040',
    notes: 'Prefers payment reminders on WhatsApp.',
  },
  {
    key: 'srilakshmi',
    name: 'Sri Lakshmi Developers',
    company: 'Sri Lakshmi Developers',
    phone: '+919000001002',
    email: 'info@srilakshmidevelopers.test',
    address: '18, Usman Road, T. Nagar, Chennai 600017',
  },
  {
    key: 'greenvalley',
    name: 'Green Valley Properties',
    company: 'Green Valley Properties LLP',
    phone: '+919000001003',
    email: 'projects@greenvalley.test',
    address: '88, Rajiv Gandhi Salai (OMR), Sholinganallur, Chennai 600119',
    notes: 'Site visits by appointment only.',
  },
];

export interface MilestoneSeed {
  title: string;
  amount: number;
  /** Negative = already due. */
  dueInDays: number;
}

export interface PaymentSeed {
  amount: number;
  daysAgo: number;
  method: PaymentMethod;
  reference?: string;
  remarks?: string;
  voided?: { daysAgo: number; reason: string };
}

export interface SiteSeed {
  key: string;
  code: string;
  name: string;
  clientKey: string;
  contactName: string;
  contactPhone: string;
  address: string;
  latitude: number;
  longitude: number;
  startedDaysAgo: number;
  completesInDays: number;
  contractAmount: number;
  progressPercent: number;
  engineerKeys: string[];
  milestones: MilestoneSeed[];
  payments: PaymentSeed[];
}

// Totals match the spec's dashboard example: received ₹24,50,000, pending ₹8,50,000.
export const SITES: SiteSeed[] = [
  {
    key: 'abc',
    code: 'SITE-001',
    name: 'ABC Apartment Project',
    clientKey: 'abc',
    contactName: 'Ramesh Babu',
    contactPhone: '+919000002001',
    address: 'Plot 12, 3rd Main Road, Anna Nagar West, Chennai 600040',
    latitude: 13.0878,
    longitude: 80.2008,
    startedDaysAgo: 216,
    completesInDays: 270,
    contractAmount: 1_500_000,
    progressPercent: 45,
    engineerKeys: ['arun'],
    milestones: [
      { title: 'Advance', amount: 300_000, dueInDays: -216 },
      { title: 'Foundation', amount: 300_000, dueInDays: -150 },
      { title: 'Plinth beam', amount: 300_000, dueInDays: -90 },
      { title: 'First floor slab', amount: 300_000, dueInDays: -20 },
      { title: 'Second floor slab', amount: 300_000, dueInDays: 40 },
    ],
    payments: [
      {
        amount: 300_000,
        daysAgo: 214,
        method: 'BANK_TRANSFER',
        reference: 'NEFT/ABC/0391',
      },
      {
        amount: 300_000,
        daysAgo: 148,
        method: 'CHEQUE',
        reference: 'CHQ 004512',
      },
      {
        amount: 300_000,
        daysAgo: 85,
        method: 'BANK_TRANSFER',
        reference: 'NEFT/ABC/0477',
      },
      {
        amount: 100_000,
        daysAgo: 30,
        method: 'CHEQUE',
        reference: 'CHQ 004561',
        voided: {
          daysAgo: 26,
          reason: 'Cheque returned unpaid (insufficient funds).',
        },
      },
      {
        amount: 200_000,
        daysAgo: 15,
        method: 'UPI',
        reference: 'UPI 6283 1145 0921',
        remarks: 'Part payment for first floor slab.',
      },
    ],
  },
  {
    key: 'greenvalley',
    code: 'SITE-002',
    name: 'Green Valley Villa',
    clientKey: 'greenvalley',
    contactName: 'Karthik Raja',
    contactPhone: '+919000002002',
    address: 'Green Valley Layout, Thalambur, Chennai 600130',
    latitude: 12.8406,
    longitude: 80.2034,
    startedDaysAgo: 182,
    completesInDays: 150,
    contractAmount: 1_000_000,
    progressPercent: 60,
    engineerKeys: ['prakash'],
    milestones: [
      { title: 'Advance', amount: 200_000, dueInDays: -180 },
      { title: 'Foundation', amount: 250_000, dueInDays: -120 },
      { title: 'Brickwork and lintel', amount: 250_000, dueInDays: -10 },
      { title: 'Finishing and handover', amount: 300_000, dueInDays: 60 },
    ],
    payments: [
      {
        amount: 200_000,
        daysAgo: 178,
        method: 'BANK_TRANSFER',
        reference: 'IMPS 7781 2201',
      },
      {
        amount: 250_000,
        daysAgo: 118,
        method: 'CHEQUE',
        reference: 'CHQ 118204',
      },
      {
        amount: 200_000,
        daysAgo: 12,
        method: 'UPI',
        reference: 'UPI 5521 9087 3310',
      },
    ],
  },
  {
    key: 'srilakshmi',
    code: 'SITE-003',
    name: 'Sri Lakshmi Commercial Building',
    clientKey: 'srilakshmi',
    contactName: 'Lakshmi Narayanan',
    contactPhone: '+919000002003',
    address: '210, Velachery Main Road, Velachery, Chennai 600042',
    latitude: 12.9791,
    longitude: 80.221,
    startedDaysAgo: 272,
    completesInDays: 45,
    contractAmount: 800_000,
    progressPercent: 80,
    engineerKeys: ['suresh', 'arun'],
    milestones: [
      { title: 'Advance', amount: 200_000, dueInDays: -270 },
      { title: 'Foundation', amount: 200_000, dueInDays: -200 },
      { title: 'Structure', amount: 200_000, dueInDays: -110 },
      { title: 'Handover', amount: 200_000, dueInDays: 25 },
    ],
    payments: [
      {
        amount: 200_000,
        daysAgo: 268,
        method: 'CHEQUE',
        reference: 'CHQ 330017',
      },
      {
        amount: 200_000,
        daysAgo: 195,
        method: 'BANK_TRANSFER',
        reference: 'NEFT/SLD/1192',
      },
      {
        amount: 200_000,
        daysAgo: 105,
        method: 'BANK_TRANSFER',
        reference: 'NEFT/SLD/1260',
      },
      {
        amount: 100_000,
        daysAgo: 6,
        method: 'CASH',
        reference: 'Receipt SL-104',
        remarks: 'Collected at site office.',
      },
    ],
  },
];

export interface StaffAssignmentSeed {
  staffKey: string;
  siteKey: string;
  engineerKey: string;
  assignedDaysAgo: number;
  habits: StaffHabits;
  /** An earlier assignment, recorded in assignment_history. */
  previous?: { siteKey: string; engineerKey: string; assignedDaysAgo: number };
}

export const STAFF_ASSIGNMENTS: StaffAssignmentSeed[] = [
  {
    staffKey: 'ravi',
    siteKey: 'abc',
    engineerKey: 'arun',
    assignedDaysAgo: 210,
    habits: { absent: 0.03, late: 0.08, halfDay: 0.02, submit: 0.96 },
  },
  {
    staffKey: 'kumar',
    siteKey: 'abc',
    engineerKey: 'arun',
    assignedDaysAgo: 60,
    habits: { absent: 0.1, late: 0.25, halfDay: 0.06, submit: 0.72 },
    previous: {
      siteKey: 'greenvalley',
      engineerKey: 'prakash',
      assignedDaysAgo: 170,
    },
  },
  {
    staffKey: 'manoj',
    siteKey: 'greenvalley',
    engineerKey: 'prakash',
    assignedDaysAgo: 175,
    habits: { absent: 0.04, late: 0.1, halfDay: 0.03, submit: 0.94 },
  },
  {
    staffKey: 'sathish',
    siteKey: 'greenvalley',
    engineerKey: 'prakash',
    assignedDaysAgo: 160,
    habits: { absent: 0.05, late: 0.12, halfDay: 0.04, submit: 0.9 },
  },
  {
    staffKey: 'vijay',
    siteKey: 'srilakshmi',
    engineerKey: 'suresh',
    assignedDaysAgo: 120,
    habits: { absent: 0.04, late: 0.1, halfDay: 0.03, submit: 0.93 },
  },
  {
    staffKey: 'muthu',
    siteKey: 'srilakshmi',
    engineerKey: 'arun',
    assignedDaysAgo: 45,
    habits: { absent: 0.06, late: 0.15, halfDay: 0.04, submit: 0.88 },
  },
];

export const WORK_DESCRIPTIONS: Record<Designation, string[]> = {
  MASON: [
    'Brickwork for 2nd floor partition walls, about 120 sq ft completed.',
    'Plastering of the ground floor ceiling in progress.',
    'Block work on the east wall, 4 courses completed.',
    "Curing of yesterday's plaster work and minor touch-ups.",
    'Laying bricks for the staircase side wall.',
  ],
  HELPER: [
    'Shifted 40 cement bags to the 2nd floor.',
    'Cleared debris from the staircase and lift lobby.',
    'Mixing mortar for the masonry team.',
    'Watering the slab for curing.',
    'Moved scaffolding pipes to the east side.',
  ],
  ELECTRICIAN: [
    'Conduit laying in the first floor slab.',
    'Concealed wiring in bedroom 2 and the hall.',
    'Fixing switch boxes in the kitchen.',
    'Mounting the distribution board on the ground floor.',
    'Earthing pit connection completed.',
  ],
  CARPENTER: [
    'Shuttering for the staircase waist slab.',
    'De-shuttering of lintel beams on the first floor.',
    'Fixing door frames on the first floor.',
    'Centering work for the sunshade.',
    'Repairing plywood sheets for the next pour.',
  ],
  PLUMBER: [
    'Laying PVC drain lines in toilet 1.',
    'Pressure testing of water supply lines.',
    'Fixing CPVC lines for the kitchen.',
    'Sump to overhead tank connection.',
    'Fixing floor traps in the bathrooms.',
  ],
  SUPERVISOR: [
    'Checked line and level for the 2nd floor walls.',
    'Coordinated material unloading at the gate.',
    'Reviewed the curing schedule with the team.',
    'Inspected scaffolding before work started.',
  ],
  PAINTER: [
    'Wall putty first coat on the 2nd floor.',
    'Primer coat on the north exterior wall.',
    'Sanding putty in the living room.',
    'Emulsion first coat in the bedrooms.',
    'Masking windows before exterior painting.',
  ],
  GENERAL_WORKER: [
    'Site cleaning and stacking of materials.',
    'Helped unload the steel delivery.',
    'Carried bricks to the first floor.',
    'Cleaned the site drainage channel.',
  ],
};

export interface EngineerUpdateSeed {
  engineerKey: string;
  siteKey: string;
  type: EngineerUpdateType;
  priority: Priority;
  title?: string;
  description: string;
  progressPercent?: number;
  daysAgo: number;
  time: string;
  viewedByAdmin: boolean;
}

export const ENGINEER_UPDATES: EngineerUpdateSeed[] = [
  {
    engineerKey: 'arun',
    siteKey: 'abc',
    type: 'PROGRESS',
    priority: 'MEDIUM',
    description:
      'First floor slab shuttering and reinforcement completed. Concreting planned for Tuesday.',
    progressPercent: 45,
    daysAgo: 6,
    time: '17:20',
    viewedByAdmin: true,
  },
  {
    engineerKey: 'arun',
    siteKey: 'abc',
    type: 'MATERIALS_REQUIRED',
    priority: 'HIGH',
    title: 'Cement and TMT bars',
    description:
      'Need 150 bags of OPC 53 cement and 2 tonnes of 12 mm TMT bars by Thursday.',
    daysAgo: 3,
    time: '11:05',
    viewedByAdmin: true,
  },
  {
    engineerKey: 'arun',
    siteKey: 'abc',
    type: 'SAFETY_CONCERN',
    priority: 'HIGH',
    title: 'Scaffolding bracing',
    description:
      'East side scaffolding needs additional bracing before plastering continues.',
    daysAgo: 1,
    time: '09:40',
    viewedByAdmin: false,
  },
  {
    engineerKey: 'prakash',
    siteKey: 'greenvalley',
    type: 'PROGRESS',
    priority: 'MEDIUM',
    description:
      'First floor brickwork completed. Electrical conduits in progress.',
    progressPercent: 60,
    daysAgo: 5,
    time: '18:10',
    viewedByAdmin: true,
  },
  {
    engineerKey: 'prakash',
    siteKey: 'greenvalley',
    type: 'CLIENT_REQUIREMENT',
    priority: 'MEDIUM',
    title: 'Extra window in master bedroom',
    description:
      'Client asked for an additional window in the master bedroom. Waiting for the revised drawing.',
    daysAgo: 2,
    time: '15:30',
    viewedByAdmin: false,
  },
  {
    engineerKey: 'suresh',
    siteKey: 'srilakshmi',
    type: 'PROGRESS',
    priority: 'MEDIUM',
    description:
      'Internal plastering completed on all floors. Painting started on the ground floor.',
    progressPercent: 80,
    daysAgo: 4,
    time: '17:45',
    viewedByAdmin: true,
  },
  {
    engineerKey: 'arun',
    siteKey: 'srilakshmi',
    type: 'COMPLETED_WORK',
    priority: 'LOW',
    title: 'Terrace waterproofing',
    description:
      'Terrace waterproofing completed and flood-tested for 24 hours. No leaks.',
    daysAgo: 3,
    time: '16:15',
    viewedByAdmin: true,
  },
  {
    engineerKey: 'suresh',
    siteKey: 'srilakshmi',
    type: 'DAILY_REPORT',
    priority: 'LOW',
    description:
      '6 workers on site. Painting on the ground floor, plumbing fixtures on the first floor. No incidents.',
    daysAgo: 1,
    time: '18:30',
    viewedByAdmin: false,
  },
];

export interface IssueSeed {
  siteKey: string;
  reporterKey: string;
  title: string;
  description: string;
  priority: Priority;
  status: IssueStatus;
  daysAgo: number;
  resolved?: { daysAgo: number; note: string };
}

export const ISSUES: IssueSeed[] = [
  {
    siteKey: 'abc',
    reporterKey: 'arun',
    title: 'Water seepage in basement retaining wall',
    description:
      'Seepage on the north retaining wall after the rain. Needs waterproofing before backfilling.',
    priority: 'HIGH',
    status: 'OPEN',
    daysAgo: 4,
  },
  {
    siteKey: 'abc',
    reporterKey: 'arun',
    title: 'Delay in TMT steel delivery',
    description:
      'Supplier has postponed delivery of 12 mm bars by a week. Slab work may slip.',
    priority: 'MEDIUM',
    status: 'IN_PROGRESS',
    daysAgo: 8,
  },
  {
    siteKey: 'greenvalley',
    reporterKey: 'prakash',
    title: 'Conduit damaged during plastering',
    description:
      'Electrical conduit in bedroom 2 was crushed during plastering.',
    priority: 'MEDIUM',
    status: 'RESOLVED',
    daysAgo: 10,
    resolved: {
      daysAgo: 7,
      note: 'Damaged section replaced and plaster patched.',
    },
  },
  {
    siteKey: 'srilakshmi',
    reporterKey: 'suresh',
    title: 'Crack in terrace parapet wall',
    description:
      'A 1.5 m hairline crack has appeared on the east parapet wall. Structural check needed.',
    priority: 'CRITICAL',
    status: 'OPEN',
    daysAgo: 1,
  },
];
