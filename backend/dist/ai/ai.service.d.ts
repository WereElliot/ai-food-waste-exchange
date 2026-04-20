import { ConfigService } from '@nestjs/config';
export declare class AiService {
    private configService;
    private hf;
    constructor(configService: ConfigService);
    predictSpoilage(imageUrl: string, itemType: string): Promise<{
        risk: string;
        confidence: number;
        label: string;
    }>;
    private fetchImageAsBlob;
    suggestRecipes(items: string[]): Promise<string[]>;
}
