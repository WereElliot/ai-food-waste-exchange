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
exports.AiService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const inference_1 = require("@huggingface/inference");
let AiService = class AiService {
    configService;
    hf;
    constructor(configService) {
        this.configService = configService;
        const apiKey = this.configService.get('HF_API_KEY');
        this.hf = new inference_1.HfInference(apiKey);
    }
    async predictSpoilage(imageUrl, itemType) {
        try {
            const result = await this.hf.imageClassification({
                data: await this.fetchImageAsBlob(imageUrl),
                model: 'google/vit-base-patch16-224',
            });
            const topResult = result[0];
            let risk = 'LOW';
            const rottenKeywords = ['rotten', 'mold', 'decay', 'fungus', 'expired'];
            const mediumKeywords = ['bruised', 'overripe', 'brown', 'withered'];
            if (rottenKeywords.some(k => topResult.label.toLowerCase().includes(k))) {
                risk = 'HIGH';
            }
            else if (mediumKeywords.some(k => topResult.label.toLowerCase().includes(k))) {
                risk = 'MEDIUM';
            }
            return {
                risk,
                confidence: topResult.score,
                label: topResult.label,
            };
        }
        catch (error) {
            console.error('HF Inference Error:', error);
            throw new common_1.InternalServerErrorException('AI Analysis failed');
        }
    }
    async fetchImageAsBlob(url) {
        const response = await fetch(url);
        return await response.blob();
    }
    async suggestRecipes(items) {
        try {
            const prompt = `Suggest 3 simple "use-it-up" recipes for these surplus food items: ${items.join(', ')}. Keep it concise.`;
            const result = await this.hf.textGeneration({
                model: 'mistralai/Mistral-7B-Instruct-v0.2',
                inputs: prompt,
                parameters: { max_new_tokens: 200 },
            });
            return result.generated_text.split('\n').filter(line => line.trim().length > 0);
        }
        catch (error) {
            console.error('HF Recipe Suggestion Error:', error);
            return ['Unable to suggest recipes at this time.'];
        }
    }
};
exports.AiService = AiService;
exports.AiService = AiService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], AiService);
//# sourceMappingURL=ai.service.js.map