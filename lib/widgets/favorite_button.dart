import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../state/favorites_controller.dart';

// Coração que adiciona/remove a receita dos favoritos (RF05).
// Usado no cartão da lista e na tela de detalhes.
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
        return IconButton(
          tooltip: saved ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
          onPressed: () => favorites.toggle(recipe),
          icon: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            color: saved ? AppColors.favorite : AppColors.title,
          ),
        );
      },
    );
  }
}
