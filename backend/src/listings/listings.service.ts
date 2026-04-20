import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateListingDto } from './dto/create-listing.dto';

@Injectable()
export class ListingsService {
  constructor(private prisma: PrismaService) {}

  async create(createListingDto: CreateListingDto, donorId: string) {
    return this.prisma.listing.create({
      data: {
        ...createListingDto,
        donorId,
      },
    });
  }

  async findAll() {
    return this.prisma.listing.findMany({
      include: { donor: true },
    });
  }

  async findNearby(lat: number, lng: number, radiusKm: number = 20) {
    // Pure SQL Haversine formula to calculate distance without PostGIS
    return this.prisma.$queryRaw`
      SELECT l.*, 
             u."fullName" as "donorName",
             (
               6371 * acos(
                 cos(radians(${lat})) * cos(radians(l.latitude)) * 
                 cos(radians(l.longitude) - radians(${lng})) + 
                 sin(radians(${lat})) * sin(radians(l.latitude))
               )
             ) as distance
      FROM "Listing" l
      JOIN "User" u ON l."donorId" = u.id
      WHERE (
        6371 * acos(
          cos(radians(${lat})) * cos(radians(l.latitude)) * 
          cos(radians(l.longitude) - radians(${lng})) + 
          sin(radians(${lat})) * sin(radians(l.latitude))
        )
      ) <= ${radiusKm}
      AND l.status = 'AVAILABLE'
      ORDER BY distance ASC;
    `;
  }

  async findOne(id: string) {
    return this.prisma.listing.findUnique({
      where: { id },
      include: { donor: true },
    });
  }

  async updateStatus(id: string, status: any) {
    return this.prisma.listing.update({
      where: { id },
      data: { status },
    });
  }
}
