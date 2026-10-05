/** Shared input patterns for DTOs. */
export const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
export const DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;
/** Up to 12 rupee digits and 2 paise digits, e.g. "850000" or "850000.50". */
export const MONEY_PATTERN = /^\d{1,12}(\.\d{1,2})?$/;
