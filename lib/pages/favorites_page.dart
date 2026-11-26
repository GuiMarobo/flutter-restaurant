import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../state/app_tab.dart';
import '../state/favorites_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/recipe_list.dart';
import '../widgets/state_view.dart';

// Aba Favoritos (RF05): receitas guardadas nesta sessão.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    icon: Icons.favorite_border_rounded,
                    title: 'Sua lista está vazia',
                    message:
                        'Toque no coração de uma receita '
                        'para guardá-la aqui.',
                    actionLabel: 'Ver receitas',
                    onAction: () => selectedTab.value = AppTab.home,
                  );
                }
                return RecipeList(
                  recipes: favorites.recipes,
                  header: SectionTitle(
                    title: 'Seus favoritos',
                    count: favorites.count,
                    subtitle: 'Guardados enquanto o app estiver aberto.',
                  ),
                  footer: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Toque no coração para tirar da lista.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
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
