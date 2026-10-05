import { toCsv } from './csv.js';

describe('toCsv', () => {
  it('quotes commas, quotes and line breaks, and starts with a BOM', () => {
    const csv = toCsv(
      ['Name', 'Note'],
      [
        ['Ravi, Kumar', 'Said "ok"\nthen left'],
        ['Arun', null],
      ],
    );
    expect(csv).toBe(
      '\uFEFFName,Note\r\n"Ravi, Kumar","Said ""ok""\nthen left"\r\nArun,\r\n',
    );
  });

  it('neutralises formulas but keeps numbers', () => {
    const csv = toCsv(
      ['A', 'B', 'C', 'D'],
      [['=HYPERLINK("x")', '+1-2', '-250000.50', '@SUM(A1)']],
    );
    expect(csv.split('\r\n')[1]).toBe(
      `"'=HYPERLINK(""x"")",'+1-2,-250000.50,'@SUM(A1)`,
    );
  });
});
