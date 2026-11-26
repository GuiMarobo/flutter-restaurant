import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../state/favorites_controller.dart';

// Coração branco e redondo que favorita/desfavorita a receita (RF05).
// Fica por cima da foto, no cartão e na tela de detalhes.
class FavoriteButton extends StatelessWidget {
  final Recipe recipe;

  const FavoriteButton({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Redesenha só o coração quando os favoritos mudam
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
