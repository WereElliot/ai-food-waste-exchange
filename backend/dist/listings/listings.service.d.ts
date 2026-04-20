import { PrismaService } from '../prisma/prisma.service';
import { CreateListingDto } from './dto/create-listing.dto';
export declare class ListingsService {
    private prisma;
    constructor(prisma: PrismaService);
    create(createListingDto: CreateListingDto, donorId: string): Promise<{
        id: string;
        title: string;
        description: string;
        photoUrl: string;
        quantity: string;
        itemType: string;
        expiryDate: Date | null;
        spoilageRisk: import(".prisma/client").$Enums.SpoilageRisk | null;
        status: import(".prisma/client").$Enums.ListingStatus;
        latitude: number;
        longitude: number;
        donorId: string;
        createdAt: Date;
        updatedAt: Date;
    }>;
    findAll(): Promise<({
        donor: {
            id: string;
            email: string;
            phoneNumber: string | null;
            fullName: string;
            role: import(".prisma/client").$Enums.UserRole;
            avatarUrl: string | null;
            locationLat: number | null;
            locationLng: number | null;
            createdAt: Date;
            updatedAt: Date;
        };
    } & {
        id: string;
        title: string;
        description: string;
        photoUrl: string;
        quantity: string;
        itemType: string;
        expiryDate: Date | null;
        spoilageRisk: import(".prisma/client").$Enums.SpoilageRisk | null;
        status: import(".prisma/client").$Enums.ListingStatus;
        latitude: number;
        longitude: number;
        donorId: string;
        createdAt: Date;
        updatedAt: Date;
    })[]>;
    findNearby(lat: number, lng: number, radiusKm?: number): Promise<unknown>;
    findOne(id: string): Promise<({
        donor: {
            id: string;
            email: string;
            phoneNumber: string | null;
            fullName: string;
            role: import(".prisma/client").$Enums.UserRole;
            avatarUrl: string | null;
            locationLat: number | null;
            locationLng: number | null;
            createdAt: Date;
            updatedAt: Date;
        };
    } & {
        id: string;
        title: string;
        description: string;
        photoUrl: string;
        quantity: string;
        itemType: string;
        expiryDate: Date | null;
        spoilageRisk: import(".prisma/client").$Enums.SpoilageRisk | null;
        status: import(".prisma/client").$Enums.ListingStatus;
        latitude: number;
        longitude: number;
        donorId: string;
        createdAt: Date;
        updatedAt: Date;
    }) | null>;
    updateStatus(id: string, status: any): Promise<{
        id: string;
        title: string;
        description: string;
        photoUrl: string;
        quantity: string;
        itemType: string;
        expiryDate: Date | null;
        spoilageRisk: import(".prisma/client").$Enums.SpoilageRisk | null;
        status: import(".prisma/client").$Enums.ListingStatus;
        latitude: number;
        longitude: number;
        donorId: string;
        createdAt: Date;
        updatedAt: Date;
    }>;
}
