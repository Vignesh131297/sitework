import { Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

/** `?page=1&limit=20&q=search` — every list endpoint extends this. */
export class PageQueryDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 20;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  q?: string;

  get skip(): number {
    return (this.page - 1) * this.limit;
  }

  /** The trimmed search term, or undefined when empty. */
  get search(): string | undefined {
    const term = this.q?.trim();
    return term ? term : undefined;
  }
}

/** Case-insensitive "contains" filter for Prisma string fields. */
export const contains = (term: string) => ({
  contains: term,
  mode: 'insensitive' as const,
});
