import { Controller, Get, Query, Res, StreamableFile } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { IsIn, IsOptional, Matches } from 'class-validator';
import type { Response } from 'express';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import { DATE_PATTERN, UUID_PATTERN } from '../common/validation/patterns.js';
import { toCsv } from './csv.js';
import {
  ReportsService,
  type EngineerReportRow,
  type PaymentReport,
  type SiteReportRow,
  type StaffReportRow,
  type StockReportRow,
} from './reports.service.js';

class ReportQueryDto {
  @Matches(DATE_PATTERN, { message: 'from must be YYYY-MM-DD' })
  from: string;

  @Matches(DATE_PATTERN, { message: 'to must be YYYY-MM-DD' })
  to: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  clientId?: string;

  /** csv: a spreadsheet download instead of JSON. */
  @IsOptional()
  @IsIn(['json', 'csv'])
  format?: 'json' | 'csv';
}

const pct = (value: number | null) => (value === null ? '' : value);

@ApiTags('reports')
@ApiBearerAuth()
@Controller('reports')
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Roles('ADMIN', 'ENGINEER')
  @Get('sites')
  async sites(
    @CurrentUser() user: AuthUser,
    @Query() query: ReportQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<SiteReportRow[] | StreamableFile> {
    const rows = await this.reports.sites(user, query);
    if (query.format !== 'csv') return rows;
    const money = user.role === 'ADMIN';
    return csv(
      res,
      `sites-${query.from}-to-${query.to}.csv`,
      [
        'Site ID',
        'Site',
        'Client',
        'Status',
        'Updates sent',
        'Updates missed',
        'Compliance %',
        'Sent offline',
        'Location flagged',
        'Present',
        'Late',
        'Half day',
        'Absent',
        'On leave',
        'Engineer updates',
        'Issues opened',
        'Issues resolved',
        'Open issues now',
        ...(money ? ['Received'] : []),
      ],
      rows.map((r) => [
        r.site.code,
        r.site.name,
        r.client.name,
        r.site.status,
        r.updates.submitted,
        r.updates.missed,
        pct(r.updates.compliancePercent),
        r.updates.offline,
        r.updates.locationFlagged,
        r.attendance.present,
        r.attendance.late,
        r.attendance.halfDay,
        r.attendance.absent,
        r.attendance.onLeave,
        r.engineerUpdates,
        r.issues.opened,
        r.issues.resolved,
        r.issues.openNow,
        ...(money ? [r.received] : []),
      ]),
    );
  }

  @Roles('ADMIN', 'ENGINEER')
  @Get('staff')
  async staff(
    @CurrentUser() user: AuthUser,
    @Query() query: ReportQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StaffReportRow[] | StreamableFile> {
    const rows = await this.reports.staff(user, query);
    if (query.format !== 'csv') return rows;
    return csv(
      res,
      `staff-${query.from}-to-${query.to}.csv`,
      [
        'Employee ID',
        'Name',
        'Designation',
        'Current site',
        'Active',
        'Present',
        'Late',
        'Half day',
        'Absent',
        'On leave',
        'Updates sent',
        'Updates missed',
        'Compliance %',
        'Sent offline',
        'Location flagged',
      ],
      rows.map((r) => [
        r.staff.employeeCode,
        r.staff.name,
        r.staff.designation,
        r.site?.name,
        r.staff.isActive ? 'Yes' : 'No',
        r.attendance.present,
        r.attendance.late,
        r.attendance.halfDay,
        r.attendance.absent,
        r.attendance.onLeave,
        r.updates.submitted,
        r.updates.missed,
        pct(r.updates.compliancePercent),
        r.updates.offline,
        r.updates.locationFlagged,
      ]),
    );
  }

  @Roles('ADMIN')
  @Get('engineers')
  async engineers(
    @Query() query: ReportQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<EngineerReportRow[] | StreamableFile> {
    const rows = await this.reports.engineers(query);
    if (query.format !== 'csv') return rows;
    return csv(
      res,
      `engineers-${query.from}-to-${query.to}.csv`,
      [
        'Employee ID',
        'Name',
        'Active',
        'Sites',
        'Updates to admin',
        'Issues reported',
        'Issues resolved',
        'Staff photos',
        'Photos reviewed',
        'Review rate %',
        'Average minutes to review',
      ],
      rows.map((r) => [
        r.engineer.employeeCode,
        r.engineer.name,
        r.engineer.isActive ? 'Yes' : 'No',
        r.sites,
        r.engineerUpdates,
        r.issues.reported,
        r.issues.resolved,
        r.reviews.photos,
        r.reviews.reviewed,
        pct(r.reviews.reviewRatePercent),
        pct(r.reviews.averageMinutes),
      ]),
    );
  }

  @Roles('ADMIN', 'ENGINEER')
  @Get('stock')
  async stock(
    @CurrentUser() user: AuthUser,
    @Query() query: ReportQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StockReportRow[] | StreamableFile> {
    const rows = await this.reports.stock(user, query);
    if (query.format !== 'csv') return rows;
    const money = user.role === 'ADMIN';
    return csv(
      res,
      `stock-${query.from}-to-${query.to}.csv`,
      [
        'Place',
        'Type',
        'Material',
        'Unit',
        'Opening',
        'Received',
        'Used',
        'Sent out',
        'Wasted',
        'Count corrections',
        'Closing',
        ...(money ? ['Used value'] : []),
      ],
      rows.map((r) => [
        r.site?.name ?? r.godown?.name,
        r.place === 'GODOWN' ? 'Godown' : 'Site',
        r.material.name,
        r.material.unit,
        r.opening,
        r.received,
        r.used,
        r.sentOut,
        r.wasted,
        r.adjusted,
        r.closing,
        ...(money ? [r.usedValue] : []),
      ]),
    );
  }

  @Roles('ADMIN')
  @Get('payments')
  async payments(
    @Query() query: ReportQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<PaymentReport | StreamableFile> {
    const report = await this.reports.payments(query);
    if (query.format !== 'csv') return report;
    return csv(
      res,
      `payments-${query.from}-to-${query.to}.csv`,
      ['Paid on', 'Amount', 'Method', 'Reference', 'Site', 'Client'],
      report.payments.map((p) => [
        p.paidOn,
        p.amount,
        p.method,
        p.reference,
        p.site.name,
        p.client.name,
      ]),
    );
  }
}

function csv(
  res: Response,
  filename: string,
  header: string[],
  rows: unknown[][],
): StreamableFile {
  res.setHeader('Cache-Control', 'private, no-store');
  return new StreamableFile(Buffer.from(toCsv(header, rows), 'utf8'), {
    type: 'text/csv; charset=utf-8',
    disposition: `attachment; filename="${filename}"`,
  });
}
