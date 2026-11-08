import { Injectable } from '@nestjs/common';
import { MasterRepository } from '../repositories/master.repository.js';

@Injectable()
export class CreateMasterUseCase {
  constructor(private readonly masterRepository: MasterRepository) {}

  async execute(file: Express.Multer.File) {
    console.log('salvo', file?.originalname);
  }
}
