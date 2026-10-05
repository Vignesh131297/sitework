/**
 * CSV for spreadsheet apps. Values starting with = + - @ (or tab/CR) are
 * prefixed with a quote so they can't run as formulas (CSV injection); a BOM
 * makes Excel read the file as UTF-8.
 */
export function toCsv(
  header: readonly string[],
  rows: readonly (readonly unknown[])[],
): string {
  const lines = [header, ...rows].map((row) => row.map(cell).join(','));
  return `\uFEFF${lines.join('\r\n')}\r\n`;
}

function cell(value: unknown): string {
  if (value === null || value === undefined) return '';
  let text = value instanceof Date ? value.toISOString() : String(value);
  // Plain numbers (including negatives) are safe; text that looks like a formula is not.
  if (/^[=+\-@\t\r]/.test(text) && !/^-?\d+(\.\d+)?$/.test(text))
    text = `'${text}`;
  return /[",\r\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
}
