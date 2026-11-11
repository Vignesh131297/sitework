import { toPaise } from '../common/money/money.js';
import {
  engineerUpdateSubmitted,
  leaveDecided,
  leaveRequested,
  milestoneOverdue,
  staffRequestCreated,
  staffRequestDecided,
  staffRequestSummary,
  staffUpdateSubmitted,
  updatesMissed,
} from './notification-messages.js';

// Wording follows the examples in the product spec.
describe('notification messages', () => {
  it('announces a staff update with the site and local time', () => {
    expect(
      staffUpdateSubmitted({
        staffName: 'Ravi',
        slot: 'MORNING',
        siteName: 'ABC Apartment',
        submittedAt: new Date('2026-10-03T05:12:00Z'),
        timeZone: 'Asia/Kolkata',
      }),
    ).toEqual({
      title: 'Ravi submitted Morning Update',
      message: 'ABC Apartment · 10:42 AM',
    });
  });

  it('names a single missing staff member', () => {
    expect(
      updatesMissed({
        staffNames: ['Ravi'],
        slot: 'MORNING',
        siteName: 'ABC Apartment',
        date: '2026-10-03',
      }),
    ).toEqual({
      title: 'Ravi has not submitted the Morning Update',
      message: 'ABC Apartment · Sat 3 Oct',
    });
  });

  it('summarises several missing staff in one notification', () => {
    expect(
      updatesMissed({
        staffNames: ['Ravi', 'Kumar', 'Manoj'],
        slot: 'EVENING',
        siteName: 'ABC Apartment',
        date: '2026-10-03',
      }),
    ).toEqual({
      title: '3 staff missed the Evening Update',
      message: 'ABC Apartment · Ravi, Kumar, Manoj',
    });
  });

  it('describes engineer updates for the admin', () => {
    expect(
      engineerUpdateSubmitted({
        engineerName: 'Arun',
        type: 'PROGRESS',
        siteName: 'ABC Apartment',
      }),
    ).toEqual({
      title: 'Engineer Arun submitted a site progress update',
      message: 'ABC Apartment',
    });
  });

  it('states the outstanding amount of an overdue milestone in rupees', () => {
    expect(
      milestoneOverdue({
        milestoneTitle: 'First floor slab',
        siteName: 'ABC Apartment',
        outstanding: toPaise(100_000),
        dueDate: '2026-09-14',
      }).message,
    ).toBe('ABC Apartment · ₹1,00,000 due since Mon 14 Sep');
  });

  it('names the leave, its days and the site for approvers', () => {
    expect(
      leaveRequested({
        code: 'LV-0003',
        name: 'Ravi',
        type: 'SICK',
        from: '2026-10-05',
        to: '2026-10-07',
        siteName: 'ABC Apartment',
      }),
    ).toEqual({
      title: 'Ravi asked for sick leave',
      message: 'LV-0003 · Mon 5 Oct – Wed 7 Oct · ABC Apartment',
    });
    expect(
      leaveRequested({
        code: 'LV-0004',
        name: 'Arun',
        type: 'OTHER',
        from: '2026-10-05',
        to: '2026-10-05',
        siteName: null,
      }),
    ).toEqual({
      title: 'Arun asked for leave',
      message: 'LV-0004 · Mon 5 Oct',
    });
  });

  it('tells the requester the decision and who made it', () => {
    expect(
      leaveDecided({
        code: 'LV-0003',
        approved: true,
        from: '2026-10-05',
        to: '2026-10-05',
        byName: 'Arun',
        note: null,
      }),
    ).toEqual({
      title: 'Your leave Mon 5 Oct was approved',
      message: 'LV-0003 · by Arun',
    });
  });

  it('describes money and food requests', () => {
    const advance = staffRequestSummary({
      kind: 'MONEY',
      amount: toPaise('2500'),
      forDate: null,
      meal: null,
    });
    expect(advance).toBe('₹2,500 advance');
    const lunch = staffRequestSummary({
      kind: 'FOOD',
      amount: null,
      forDate: '2026-10-05',
      meal: 'LUNCH',
    });
    expect(lunch).toBe('Lunch on Mon 5 Oct');
    expect(
      staffRequestCreated({
        code: 'RQ-0001',
        name: 'Ravi',
        summary: lunch,
        siteName: 'ABC Apartment',
      }),
    ).toEqual({
      title: 'Ravi asked for lunch on Mon 5 Oct',
      message: 'RQ-0001 · ABC Apartment',
    });
    expect(
      staffRequestDecided({
        code: 'RQ-0001',
        summary: advance,
        approved: false,
        byName: 'Admin',
        note: 'Already given this month',
      }),
    ).toEqual({
      title: '₹2,500 advance rejected',
      message: 'RQ-0001 · by Admin · Already given this month',
    });
  });
});
