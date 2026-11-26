import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/recipe.dart';
import 'recipe_card.dart';

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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        ?header,
        for (final recipe in recipes)
          RecipeCard(
            key: ValueKey(recipe.id),
            recipe: recipe,
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.detail, arguments: recipe),
          ),
        ?footer,
      ],
    );
  }
}
