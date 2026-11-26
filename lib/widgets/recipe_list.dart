import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/recipe.dart';
import 'recipe_card.dart';

// Lista rolável de receitas (RF02), usada em Explorar, Pesquisa e Favoritos.
// [header] aparece antes dos cartões e [footer] depois, rolando junto.
class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final Widget? header;
  final Widget? footer;

  const RecipeList({
    super.key,
    required this.recipes,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        ?header, // "?" = só entra na lista se não for null
        for (final recipe in recipes)
          RecipeCard(
            // A key pelo id ajuda o Flutter a reaproveitar o cartão certo
            key: ValueKey(recipe.id),
            recipe: recipe,
            // Abre os detalhes da receita selecionada (RF04 / RF09)
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.detail, arguments: recipe),
          ),
        ?footer,
      ],
    );
  }
}
