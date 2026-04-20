import { AiService } from './ai.service';
export declare class AiController {
    private readonly aiService;
    constructor(aiService: AiService);
    predictSpoilage(body: {
        imageUrl: string;
        itemType: string;
    }): Promise<{
        risk: string;
        confidence: number;
        label: string;
    }>;
    suggestRecipes(body: {
        items: string[];
    }): Promise<string[]>;
}
