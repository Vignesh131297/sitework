import { Global, Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createTransport, type Transporter } from 'nodemailer';
import type { Env } from '../config/env.js';

export interface MailMessage {
  to: string;
  subject: string;
  text: string;
}

/** Sends transactional e-mail. Inject this; the driver is chosen by MAIL_DRIVER. */
export abstract class MailSender {
  abstract readonly enabled: boolean;
  abstract send(message: MailMessage): Promise<void>;
}

class DisabledMailSender extends MailSender {
  readonly enabled = false;

  send(): Promise<void> {
    return Promise.reject(
      new Error('E-mail is disabled (MAIL_DRIVER=disabled).'),
    );
  }
}

/** Development: writes messages to the log instead of sending them. */
class LogMailSender extends MailSender {
  readonly enabled = true;
  private readonly logger = new Logger('Mail');

  send(message: MailMessage): Promise<void> {
    this.logger.log(`To ${message.to}: ${message.subject}\n${message.text}`);
    return Promise.resolve();
  }
}

class SmtpMailSender extends MailSender {
  readonly enabled = true;
  private readonly transport: Transporter;

  constructor(
    url: string,
    private readonly from: string,
  ) {
    super();
    this.transport = createTransport(url);
  }

  async send(message: MailMessage): Promise<void> {
    await this.transport.sendMail({ from: this.from, ...message });
  }
}

@Global()
@Module({
  providers: [
    {
      provide: MailSender,
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>): MailSender => {
        switch (config.get('MAIL_DRIVER', { infer: true })) {
          case 'log':
            return new LogMailSender();
          case 'smtp':
            return new SmtpMailSender(
              config.get('SMTP_URL', { infer: true }) ?? '',
              config.get('MAIL_FROM', { infer: true }),
            );
          default:
            return new DisabledMailSender();
        }
      },
    },
  ],
  exports: [MailSender],
})
export class MailModule {}
