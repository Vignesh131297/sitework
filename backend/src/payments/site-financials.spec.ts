import { siteFinancials, totalFinancials } from './site-financials.js';

const date = (iso: string) => new Date(`${iso}T00:00:00.000Z`);

const abc = siteFinancials(
  {
    contractAmount: '1500000.00',
    payments: [
      { amount: '300000.00', voidedAt: null },
      { amount: '100000.00', voidedAt: new Date() }, // bounced cheque
      { amount: '800000.00', voidedAt: null },
    ],
    milestones: [
      {
        id: 'm1',
        title: 'Advance',
        amount: '300000',
        dueDate: date('2026-03-01'),
      },
      {
        id: 'm2',
        title: 'Foundation',
        amount: '900000',
        dueDate: date('2026-09-01'),
      },
      {
        id: 'm3',
        title: 'Handover',
        amount: '300000',
        dueDate: date('2026-12-01'),
      },
    ],
  },
  '2026-10-05',
);

describe('siteFinancials', () => {
  it('ignores voided payments and derives pending from the contract', () => {
    expect(abc).toMatchObject({
      contract: '1500000.00',
      received: '1100000.00',
      pending: '400000.00',
    });
  });

  it('reports overdue milestone amounts', () => {
    expect(abc.overdue).toBe('100000.00');
    expect(abc.overdueCount).toBe(1);
    expect(abc.milestones.map((m) => [m.title, m.status])).toEqual([
      ['Advance', 'PAID'],
      ['Foundation', 'OVERDUE'],
      ['Handover', 'PENDING'],
    ]);
  });

  it('never shows negative pending when more was received than the contract', () => {
    const overpaid = siteFinancials(
      {
        contractAmount: '1000',
        payments: [{ amount: '1200', voidedAt: null }],
        milestones: [],
      },
      '2026-10-05',
    );
    expect(overpaid.pending).toBe('0.00');
  });

  it('adds up sites exactly', () => {
    expect(totalFinancials([abc, abc])).toEqual({
      contract: '3000000.00',
      received: '2200000.00',
      pending: '800000.00',
      overdue: '200000.00',
      overdueCount: 2,
    });
  });
});
