import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../state/app_tab.dart';
import '../state/favorites_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/recipe_list.dart';
import '../widgets/state_view.dart';

// Aba Favoritos (RF05): receitas salvas nesta sessão.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(),
          Expanded(
            // Redesenha sempre que um favorito é adicionado ou removido
            child: ListenableBuilder(
              listenable: favorites,
              builder: (context, _) {
                // Favoritos vazios: mensagem própria, diferente de erro (RF08)
                if (favorites.isEmpty) {
                  return StateView(
                    icon: Icons.favorite_border,
                    title: 'Nenhum favorito',
                    message:
                        'Marque uma receita como favorita para '
                        'encontrá-la aqui.',
                    actionLabel: 'Explorar receitas',
                    onAction: () => selectedTab.value = AppTab.explore,
                  );
                }
                return RecipeList(
                  recipes: favorites.recipes,
                  header: const SectionTitle(
                    title: 'Favoritos',
                    subtitle: 'Receitas salvas nesta sessão.',
                    large: true,
                  ),
                  footer: const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'Toque no coração para remover.',
                      style: TextStyle(color: AppColors.text),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
