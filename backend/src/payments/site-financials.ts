import {
  fromPaise,
  sumPaise,
  toPaise,
  type Paise,
} from '../common/money/money.js';
import {
  allocatePayments,
  type MilestoneStatus,
} from './payment-allocation.js';

export interface FinancialInput {
  contractAmount: { toString(): string };
  payments: { amount: { toString(): string }; voidedAt: Date | null }[];
  milestones: {
    id: string;
    title: string;
    amount: { toString(): string };
    dueDate: Date;
  }[];
}

export interface MilestoneView {
  id: string;
  title: string;
  amount: string;
  dueDate: string;
  paid: string;
  outstanding: string;
  status: MilestoneStatus;
}

export interface SiteFinancials {
  contract: string;
  received: string;
  /** Contract minus received, never below zero. */
  pending: string;
  /** Outstanding on milestones whose due date has passed. */
  overdue: string;
  overdueCount: number;
  milestones: MilestoneView[];
}

/** All money figures for one site, derived from its records (never stored). */
export function siteFinancials(
  input: FinancialInput,
  today: string,
): SiteFinancials {
  const contract = toPaise(input.contractAmount);
  const received = sumPaise(
    input.payments
      .filter((p) => p.voidedAt === null)
      .map((p) => toPaise(p.amount)),
  );
  const titles = new Map(input.milestones.map((m) => [m.id, m.title]));
  const allocation = allocatePayments(
    input.milestones.map((m) => ({
      id: m.id,
      amount: toPaise(m.amount),
      dueDate: m.dueDate.toISOString().slice(0, 10),
    })),
    received,
    today,
  );
  const overdue = allocation.milestones.filter((m) => m.status === 'OVERDUE');
  const pending: Paise = contract > received ? contract - received : 0n;
  return {
    contract: fromPaise(contract),
    received: fromPaise(received),
    pending: fromPaise(pending),
    overdue: fromPaise(sumPaise(overdue.map((m) => m.outstanding))),
    overdueCount: overdue.length,
    milestones: allocation.milestones.map((m) => ({
      id: m.id,
      title: titles.get(m.id) ?? '',
      amount: fromPaise(m.amount),
      dueDate: m.dueDate,
      paid: fromPaise(m.paid),
      outstanding: fromPaise(m.outstanding),
      status: m.status,
    })),
  };
}

/** Adds up several sites' figures. */
export function totalFinancials(
  sites: SiteFinancials[],
): Omit<SiteFinancials, 'milestones'> {
  const sum = (pick: (s: SiteFinancials) => string) =>
    fromPaise(sumPaise(sites.map((s) => toPaise(pick(s)))));
  return {
    contract: sum((s) => s.contract),
    received: sum((s) => s.received),
    pending: sum((s) => s.pending),
    overdue: sum((s) => s.overdue),
    overdueCount: sites.reduce((n, s) => n + s.overdueCount, 0),
  };
}
