import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerOptionsExcel } from '../../upload-dto/file-upload.dto.js';
import { CreateMasterUseCase } from '../usecases/create-master.usecase.js';

@Controller('master')
export class MasterController {
  constructor(private readonly createMasterUseCase: CreateMasterUseCase) {}

  @Post()
  @UseInterceptors(FileInterceptor('file', multerOptionsExcel))
  uploadExcel(@UploadedFile() file: Express.Multer.File) {
    return this.createMasterUseCase.execute(file);
  }
}
