import { toPaise } from '../common/money/money.js';
import {
  engineerUpdateSubmitted,
  milestoneOverdue,
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
});
