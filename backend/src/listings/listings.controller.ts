import { Controller, Get, Post, Body, Param, Query, Patch } from '@nestjs/common';
import { ListingsService } from './listings.service';
import { CreateListingDto } from './dto/create-listing.dto';

@Controller('listings')
export class ListingsController {
  constructor(private readonly listingsService: ListingsService) {}

  @Post()
  async create(@Body() createListingDto: CreateListingDto) {
    // For MVP, using a mock donorId. In production, use req.user.id from AuthGuard
    const donorId = 'mock-donor-id'; 
    return this.listingsService.create(createListingDto, donorId);
  }

  @Get()
  async findAll() {
    return this.listingsService.findAll();
  }

  @Get('nearby')
  async findNearby(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius: string,
  ) {
    return this.listingsService.findNearby(
      parseFloat(lat),
      parseFloat(lng),
      radius ? parseFloat(radius) : 20,
    );
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.listingsService.findOne(id);
  }

  @Patch(':id/status')
  async updateStatus(@Param('id') id: string, @Body() body: { status: string }) {
    return this.listingsService.updateStatus(id, body.status);
  }
}
