import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HfInference } from '@huggingface/inference';

@Injectable()
export class AiService {
  private hf: HfInference;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('HF_API_KEY');
    this.hf = new HfInference(apiKey);
  }

  async predictSpoilage(imageUrl: string, itemType: string): Promise<{ risk: string; confidence: number; label: string }> {
    try {
      // For MVP, we use a general image classification model
      // In production, we'd use a fine-tuned model for food freshness
      const result = await this.hf.imageClassification({
        data: await this.fetchImageAsBlob(imageUrl),
        model: 'google/vit-base-patch16-224', // Placeholder model
      });

      // Simple logic to map labels to spoilage risk
      // This is a simplified example. In reality, you'd check for "mold", "rotten", etc.
      const topResult = result[0];
      let risk = 'LOW';
      
      const rottenKeywords = ['rotten', 'mold', 'decay', 'fungus', 'expired'];
      const mediumKeywords = ['bruised', 'overripe', 'brown', 'withered'];

      if (rottenKeywords.some(k => topResult.label.toLowerCase().includes(k))) {
        risk = 'HIGH';
      } else if (mediumKeywords.some(k => topResult.label.toLowerCase().includes(k))) {
        risk = 'MEDIUM';
      }

      return {
        risk,
        confidence: topResult.score,
        label: topResult.label,
      };
    } catch (error) {
      console.error('HF Inference Error:', error);
      throw new InternalServerErrorException('AI Analysis failed');
    }
  }

  private async fetchImageAsBlob(url: string): Promise<Blob> {
    const response = await fetch(url);
    return await response.blob();
  }

  async suggestRecipes(items: string[]): Promise<string[]> {
    try {
      // Use a text-generation model for recipes
      const prompt = `Suggest 3 simple "use-it-up" recipes for these surplus food items: ${items.join(', ')}. Keep it concise.`;
      const result = await this.hf.textGeneration({
        model: 'mistralai/Mistral-7B-Instruct-v0.2',
        inputs: prompt,
        parameters: { max_new_tokens: 200 },
      });

      return result.generated_text.split('\n').filter(line => line.trim().length > 0);
    } catch (error) {
      console.error('HF Recipe Suggestion Error:', error);
      return ['Unable to suggest recipes at this time.'];
    }
  }
}
