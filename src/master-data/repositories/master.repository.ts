import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service.js';

@Injectable()
export class MasterRepository {
  constructor(private readonly prisma: PrismaService) {}

  async createMaster(data: any): Promise<any> {
    return this.prisma.produto.create({
      data,
    });
  }
}
