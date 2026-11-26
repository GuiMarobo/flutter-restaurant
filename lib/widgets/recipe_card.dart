import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../utils/formatters.dart';
import 'favorite_button.dart';
import 'recipe_image.dart';

// Cartão de uma receita: imagem, nome, tempo, dificuldade, nota e coração.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rating = formatRating(recipe.rating);

    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              RecipeImage(url: recipe.image, width: 100, height: 110),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome longo: no máximo 2 linhas com "..."
                      Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        joinInfo([
                          formatTime(recipe),
                          formatDifficulty(recipe.difficulty),
                        ]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rating ?? 'Sem avaliação',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FavoriteButton(recipe: recipe),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
