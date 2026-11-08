import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { MasterController } from './controller/master.controller.js';
import { MasterRepository } from './repositories/master.repository.js';
import { CreateMasterUseCase } from './usecases/create-master.usecase.js';

@Module({
  controllers: [MasterController],
  providers: [CreateMasterUseCase, MasterRepository, PrismaService],
  exports: [CreateMasterUseCase],
})
export class MasterModule {}
