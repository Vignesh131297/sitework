import { Global, Injectable, Module } from '@nestjs/common';

/**
 * The current time for business rules (slot windows, check-in, photo expiry).
 * Inject it instead of calling `new Date()`, so tests can run at a chosen time.
 */
export abstract class Clock {
  abstract now(): Date;
}

@Injectable()
export class SystemClock extends Clock {
  now(): Date {
    return new Date();
  }
}

@Global()
@Module({
  providers: [{ provide: Clock, useClass: SystemClock }],
  exports: [Clock],
})
export class ClockModule {}
