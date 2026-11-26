import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../state/favorites_controller.dart';
import '../utils/formatters.dart';
import '../widgets/favorite_button.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton.filled(
                tooltip: 'Voltar',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.ink,
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            actions: [
              FavoriteButton(recipe: recipe),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: RecipeImage(url: recipe.image, iconSize: 80),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                if (recipe.cuisine != null)
                  Text(
                    recipe.cuisine!.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  recipe.name,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                _Stats(recipe: recipe),
                const SizedBox(height: 10),
                Text(
                  'Preparo: ${_minutes(recipe.prepTimeMinutes)}  ·  '
                  'Cozimento: ${_minutes(recipe.cookTimeMinutes)}',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
                if (recipe.mealType.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final type in recipe.mealType)
                        Chip(
                          avatar: const Icon(
                            Icons.local_dining,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: Text(type),
                          shape: const StadiumBorder(
                            side: BorderSide(color: AppColors.border),
                          ),
                          backgroundColor: AppColors.surface,
                        ),
                    ],
                  ),
                ],

                _SectionHeader(
                  title: 'Ingredientes',
                  count: recipe.ingredients.length,
                ),
                if (recipe.ingredients.isEmpty)
                  const _Note('Ingredientes não informados.')
                else
                  _WhiteBox(
                    children: [
                      for (final ingredient in recipe.ingredients)
                        _Ingredient(text: ingredient),
                    ],
                  ),

                _SectionHeader(
                  title: 'Passo a passo',
                  count: recipe.instructions.length,
                ),
                if (recipe.instructions.isEmpty)
                  const _Note('Modo de preparo não informado.')
                else
                  for (var i = 0; i < recipe.instructions.length; i++)
                    _Step(number: i + 1, text: recipe.instructions[i]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: ListenableBuilder(
            listenable: favorites,
            builder: (context, _) {
              final saved = favorites.isFavorite(recipe);
              return saved
                  ? OutlinedButton.icon(
                      onPressed: () => favorites.toggle(recipe),
                      icon: const Icon(
                        Icons.favorite,
                        color: AppColors.favorite,
                      ),
                      label: const Text('Remover dos favoritos'),
                    )
                  : FilledButton.icon(
                      onPressed: () => favorites.toggle(recipe),
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Salvar nos favoritos'),
                    );
            },
          ),
        ),
      ),
    );
  }

  static String _minutes(int? value) =>
      value == null ? 'não informado' : '$value min';
}

class _Stats extends StatelessWidget {
  final Recipe recipe;

  const _Stats({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final total = recipe.totalMinutes;
    final rating = formatRating(recipe.rating);
    final difficulty = formatDifficulty(recipe.difficulty);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              icon: Icons.timer_outlined,
              value: total == null ? '—' : '$total min',
              label: total == null ? 'sem tempo' : 'total',
            ),
          ),
          if (recipe.servings != null)
            Expanded(
              child: _Stat(
                icon: Icons.people_outline,
                value: '${recipe.servings}',
                label: 'porções',
              ),
            ),
          if (rating != null)
            Expanded(
              child: _Stat(
                icon: Icons.star_rounded,
                value: rating,
                label: 'nota',
              ),
            ),
          if (difficulty != null)
            Expanded(
              child: _Stat(
                icon: Icons.signal_cellular_alt,
                value: difficulty,
                label: 'nível',
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Row(
        spacing: 8,
        children: [
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w800),
            ),
          ),
          if (count > 0)
            Text(
              '· $count',
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _WhiteBox extends StatelessWidget {
  final List<Widget> children;

  const _WhiteBox({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Ingredient extends StatelessWidget {
  final String text;

  const _Ingredient({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: AppColors.primary,
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  final String text;

  const _Note(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: AppColors.muted));
  }
}
