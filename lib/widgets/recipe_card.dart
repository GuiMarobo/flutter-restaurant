import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../utils/formatters.dart';
import 'favorite_button.dart';
import 'recipe_image.dart';

// Cartão vertical: foto grande em cima, nome e informações embaixo.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rating = formatRating(recipe.rating);
    final difficulty = formatDifficulty(recipe.difficulty);

    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack coloca a nota e o coração por cima da foto
            Stack(
              children: [
                RecipeImage(url: recipe.image, height: 170),
                if (rating != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _RatingBadge(rating: rating),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: FavoriteButton(recipe: recipe),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Nome longo: no máximo 2 linhas com "..."
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _IconText(icon: Icons.schedule, text: formatTime(recipe)),
                      if (difficulty != null)
                        _IconText(
                          icon: Icons.signal_cellular_alt,
                          text: difficulty,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Etiqueta branca com estrela e nota: ★ 4,6
class _RatingBadge extends StatelessWidget {
  final String rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
          Text(
            rating,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Ícone pequeno + texto: 🕒 35 min
class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        Text(
          text,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}
