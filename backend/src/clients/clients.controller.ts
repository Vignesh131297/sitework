import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { PartialType } from '@nestjs/swagger';
import { IsOptional, IsString, Length, MaxLength } from 'class-validator';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import { Paginated } from '../common/pagination/paginated.js';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import {
  ClientsService,
  type ClientDetail,
  type ClientSummary,
} from './clients.service.js';

export class CreateClientDto {
  @IsString()
  @Length(2, 120)
  name: string;

  @IsOptional()
  @IsString()
  @MaxLength(160)
  company?: string | null;

  @IsString()
  @Length(6, 20)
  phone: string;

  @IsOptional()
  @IsString()
  @MaxLength(254)
  email?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  address?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  notes?: string | null;
}

export class UpdateClientDto extends PartialType(CreateClientDto) {}

@Roles('ADMIN')
@Controller('clients')
export class ClientsController {
  constructor(private readonly clients: ClientsService) {}

  @Get()
  list(@Query() query: PageQueryDto): Promise<Paginated<ClientSummary>> {
    return this.clients.list(query);
  }

  @Post()
  create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CreateClientDto,
  ): Promise<ClientDetail> {
    return this.clients.create(actor, dto);
  }

  @Get(':id')
  get(@Param('id', ParseIdPipe) id: string): Promise<ClientDetail> {
    return this.clients.get(id);
  }

  @Patch(':id')
  update(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateClientDto,
  ): Promise<ClientDetail> {
    return this.clients.update(actor, id, dto);
  }
}
