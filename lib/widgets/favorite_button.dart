import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../state/favorites_controller.dart';

class FavoriteButton extends StatelessWidget {
  final Recipe recipe;

  const FavoriteButton({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) {
        final saved = favorites.isFavorite(recipe);
        return IconButton.filled(
          tooltip: saved ? 'Desfavoritar' : 'Favoritar',
          onPressed: () => favorites.toggle(recipe),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            elevation: 2,
            shadowColor: Colors.black26,
          ),
          icon: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            color: saved ? AppColors.favorite : AppColors.ink,
          ),
        );
      },
    );
  }
}
