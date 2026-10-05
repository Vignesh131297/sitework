import type { Paise } from '../common/money/money.js';

export type MilestoneStatus = 'PAID' | 'PARTIALLY_PAID' | 'PENDING' | 'OVERDUE';

export interface MilestoneInput {
  id: string;
  amount: Paise;
  /** Business date, YYYY-MM-DD. */
  dueDate: string;
}

export interface MilestoneAllocation extends MilestoneInput {
  paid: Paise;
  outstanding: Paise;
  status: MilestoneStatus;
}

/**
 * Applies everything received for a site to its milestones in due-date order (oldest
 * first), so nobody has to allocate payments by hand. A milestone is OVERDUE when its
 * due date has passed and it isn't fully covered, even if partly paid.
 */
export function allocatePayments(
  milestones: readonly MilestoneInput[],
  totalReceived: Paise,
  today: string,
): { milestones: MilestoneAllocation[]; unallocated: Paise } {
  let remaining = totalReceived > 0n ? totalReceived : 0n;
  const ordered = [...milestones].sort(
    (a, b) => a.dueDate.localeCompare(b.dueDate) || a.id.localeCompare(b.id),
  );

  const allocations = ordered.map((milestone) => {
    const paid = remaining >= milestone.amount ? milestone.amount : remaining;
    remaining -= paid;
    const outstanding = milestone.amount - paid;
    return {
      ...milestone,
      paid,
      outstanding,
      status: statusOf(paid, outstanding, milestone.dueDate, today),
    };
  });

  return { milestones: allocations, unallocated: remaining };
}

function statusOf(
  paid: Paise,
  outstanding: Paise,
  dueDate: string,
  today: string,
): MilestoneStatus {
  if (outstanding === 0n) return 'PAID';
  if (dueDate < today) return 'OVERDUE';
  return paid > 0n ? 'PARTIALLY_PAID' : 'PENDING';
}
