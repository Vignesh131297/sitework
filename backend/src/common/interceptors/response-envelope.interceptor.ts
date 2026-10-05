import {
  Injectable,
  StreamableFile,
  type CallHandler,
  type ExecutionContext,
  type NestInterceptor,
} from '@nestjs/common';
import { map, type Observable } from 'rxjs';
import { Paginated } from '../pagination/paginated.js';

/** Wraps successful JSON responses as `{ success: true, data, meta? }`. */
@Injectable()
export class ResponseEnvelopeInterceptor implements NestInterceptor {
  intercept(
    _context: ExecutionContext,
    next: CallHandler,
  ): Observable<unknown> {
    return next.handle().pipe(
      map((body: unknown) => {
        if (body instanceof StreamableFile) return body;
        if (body instanceof Paginated) {
          return { success: true, data: body.items, meta: body.meta };
        }
        return { success: true, data: body ?? null };
      }),
    );
  }
}
