import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MasterModule } from './master-data/master.module.js';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true }), MasterModule],
})
export class AppModule {}
