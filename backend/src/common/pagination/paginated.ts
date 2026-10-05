export interface PageMeta {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

/**
 * Return this from a controller to get `{ success: true, data: items, meta }`
 * (see ResponseEnvelopeInterceptor).
 */
export class Paginated<T> {
  readonly meta: PageMeta;

  constructor(
    readonly items: T[],
    page: number,
    limit: number,
    total: number,
  ) {
    this.meta = {
      page,
      limit,
      total,
      totalPages: Math.max(1, Math.ceil(total / limit)),
    };
  }
}
