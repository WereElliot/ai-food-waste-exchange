declare enum SpoilageRisk {
    LOW = "LOW",
    MEDIUM = "MEDIUM",
    HIGH = "HIGH"
}
export declare class CreateListingDto {
    title: string;
    description: string;
    photoUrl: string;
    quantity: string;
    itemType: string;
    expiryDate?: string;
    spoilageRisk?: SpoilageRisk;
    latitude: number;
    longitude: number;
}
export {};
