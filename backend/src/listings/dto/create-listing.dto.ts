import { IsString, IsNumber, IsOptional, IsEnum, IsUrl, IsDateString } from 'class-validator';

enum SpoilageRisk {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
}

export class CreateListingDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsUrl()
  photoUrl: string;

  @IsString()
  quantity: string;

  @IsString()
  itemType: string;

  @IsDateString()
  @IsOptional()
  expiryDate?: string;

  @IsEnum(SpoilageRisk)
  @IsOptional()
  spoilageRisk?: SpoilageRisk;

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;
}
