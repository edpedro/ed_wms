import { BadRequestException } from '@nestjs/common';
import { MulterOptions } from '@nestjs/platform-express/multer/interfaces/multer-options.interface';
import { memoryStorage } from 'multer';

export const multerOptions: MulterOptions = {
  storage: memoryStorage(),
  limits: {
    fileSize: 50 * 1024 * 1024, // 50MB
  },
};

export const multerOptionsExcel: MulterOptions = {
  storage: memoryStorage(),
  fileFilter: (req, file, callback) => {
    const allowedMimeTypes = [
      'application/vnd.ms-excel', // .xls
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // .xlsx
    ];
    if (!allowedMimeTypes.includes(file.mimetype)) {
      return callback(
        new BadRequestException('Apenas arquivos Excel são permitidos!'),
        false,
      );
    }
    callback(null, true);
  },
  limits: {
    fileSize: 50 * 1024 * 1024, // 50MB
  },
};
