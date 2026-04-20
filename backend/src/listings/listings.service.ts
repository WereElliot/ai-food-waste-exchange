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
    // PostGIS query for nearby listings
    // radiusKm * 1000 for meters
    return this.prisma.$queryRaw`
      SELECT l.*, 
             u.fullName as "donorName",
             ST_Distance(
               ST_MakePoint(l.longitude, l.latitude)::geography,
               ST_MakePoint(${lng}, ${lat})::geography
             ) / 1000 as distance
      FROM "Listing" l
      JOIN "User" u ON l."donorId" = u.id
      WHERE ST_DWithin(
        ST_MakePoint(l.longitude, l.latitude)::geography,
        ST_MakePoint(${lng}, ${lat})::geography,
        ${radiusKm * 1000}
      )
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
