"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ListingsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ListingsService = class ListingsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createListingDto, donorId) {
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
    async findNearby(lat, lng, radiusKm = 20) {
        return this.prisma.$queryRaw `
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
    async findOne(id) {
        return this.prisma.listing.findUnique({
            where: { id },
            include: { donor: true },
        });
    }
    async updateStatus(id, status) {
        return this.prisma.listing.update({
            where: { id },
            data: { status },
        });
    }
};
exports.ListingsService = ListingsService;
exports.ListingsService = ListingsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ListingsService);
//# sourceMappingURL=listings.service.js.map