import { fromPaise, toPaise } from '../common/money/money.js';
import { allocatePayments } from './payment-allocation.js';

const today = '2026-10-04';
const milestone = (id: string, rupees: number, dueDate: string) => ({
  id,
  amount: toPaise(rupees),
  dueDate,
});

describe('allocatePayments', () => {
  it('fills milestones oldest-due first; an underpaid past-due milestone is OVERDUE', () => {
    const { milestones, unallocated } = allocatePayments(
      [
        milestone('slab-2', 300_000, '2026-11-13'),
        milestone('advance', 300_000, '2026-03-02'),
        milestone('slab-1', 300_000, '2026-09-14'),
      ],
      toPaise(500_000),
      today,
    );
    expect(
      milestones.map((m) => ({
        id: m.id,
        status: m.status,
        paid: fromPaise(m.paid),
        outstanding: fromPaise(m.outstanding),
      })),
    ).toEqual([
      { id: 'advance', status: 'PAID', paid: '300000.00', outstanding: '0.00' },
      {
        id: 'slab-1',
        status: 'OVERDUE',
        paid: '200000.00',
        outstanding: '100000.00',
      },
      {
        id: 'slab-2',
        status: 'PENDING',
        paid: '0.00',
        outstanding: '300000.00',
      },
    ]);
    expect(unallocated).toBe(0n);
  });

  it('marks a partly paid milestone that is not yet due as PARTIALLY_PAID', () => {
    const { milestones } = allocatePayments(
      [milestone('handover', 200_000, '2026-10-29')],
      toPaise(100_000),
      today,
    );
    expect(milestones[0].status).toBe('PARTIALLY_PAID');
  });

  it('does not treat a milestone due today as overdue', () => {
    const { milestones } = allocatePayments(
      [milestone('m', 1_000, today)],
      0n,
      today,
    );
    expect(milestones[0].status).toBe('PENDING');
  });

  it('reports money received beyond the schedule as unallocated', () => {
    const result = allocatePayments(
      [milestone('m', 1_000, today)],
      toPaise(1_500),
      today,
    );
    expect(result.milestones[0].status).toBe('PAID');
    expect(result.unallocated).toBe(toPaise(500));
  });

  it('ignores a negative total', () => {
    const { milestones } = allocatePayments(
      [milestone('m', 1_000, '2026-12-01')],
      -5n,
      today,
    );
    expect(milestones[0]).toMatchObject({ paid: 0n, status: 'PENDING' });
  });
});
