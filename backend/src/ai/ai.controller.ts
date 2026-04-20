import { Controller, Post, Body } from '@nestjs/common';
import { AiService } from './ai.service';

@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('predict-spoilage')
  async predictSpoilage(@Body() body: { imageUrl: string; itemType: string }) {
    return this.aiService.predictSpoilage(body.imageUrl, body.itemType);
  }

  @Post('suggest-recipes')
  async suggestRecipes(@Body() body: { items: string[] }) {
    return this.aiService.suggestRecipes(body.items);
  }
}
