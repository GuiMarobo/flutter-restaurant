import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../state/favorites_controller.dart';
import '../utils/formatters.dart';
import '../widgets/favorite_button.dart';
import '../widgets/recipe_image.dart';

// Detalhes da receita selecionada (RF04).
//
// Recebe o objeto Recipe completo que veio da listagem/pesquisa
// (não precisa chamar /recipes/{id} de novo — ver recipe_service.dart).
class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sectionStyle = textTheme.titleLarge?.copyWith(
      color: AppColors.title,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receita'),
        actions: [
          FavoriteButton(recipe: recipe),
          const SizedBox(width: 8),
        ],
      ),
      // ListView: o conteúdo inteiro rola, mesmo com muitos passos
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          RecipeImage(url: recipe.image, height: 200, iconSize: 72, radius: 20),
          const SizedBox(height: 20),
          Text(
            recipe.name,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            joinInfo([
              recipe.cuisine,
              formatDifficulty(recipe.difficulty),
              formatRating(recipe.rating),
            ]),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.text),
          ),
          // mealType é uma LISTA (pode ter vários tipos de refeição)
          if (recipe.mealType.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in recipe.mealType)
                  Chip(
                    label: Text(type),
                    backgroundColor: AppColors.soft,
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          _InfoBoxes(recipe: recipe),
          const SizedBox(height: 8),
          Text(
            'Preparo: ${_minutes(recipe.prepTimeMinutes)}  •  '
            'Cozimento: ${_minutes(recipe.cookTimeMinutes)}',
            style: textTheme.bodySmall?.copyWith(color: AppColors.text),
          ),

          // ---- Ingredientes ----
          const SizedBox(height: 24),
          Text('Ingredientes', style: sectionStyle),
          const SizedBox(height: 8),
          if (recipe.ingredients.isEmpty)
            const _Missing('Ingredientes não informados.')
          else
            for (final ingredient in recipe.ingredients)
              _Bullet(text: ingredient),

          // ---- Modo de preparo (mantém a ordem da API) ----
          const SizedBox(height: 24),
          Text('Modo de preparo', style: sectionStyle),
          const SizedBox(height: 8),
          if (recipe.instructions.isEmpty)
            const _Missing('Modo de preparo não informado.')
          else
            for (var i = 0; i < recipe.instructions.length; i++)
              _Step(number: i + 1, text: recipe.instructions[i]),

          const SizedBox(height: 24),
          const _Missing('Role para ler todos os ingredientes e passos.'),
        ],
      ),
    );
  }

  static String _minutes(int? value) =>
      value == null ? 'não informado' : '$value min';
}

// Três caixinhas: tempo total, porções e se está nos favoritos.
class _InfoBoxes extends StatelessWidget {
  final Recipe recipe;

  const _InfoBoxes({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final total = recipe.totalMinutes;
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _InfoBox(
            value: total == null ? '—' : '$total min',
            label: total == null ? 'tempo não informado' : 'tempo total',
          ),
        ),
        // Porções só aparecem quando a API manda um valor utilizável
        if (recipe.servings != null)
          Expanded(
            child: _InfoBox(value: '${recipe.servings}', label: 'porções'),
          ),
        Expanded(
          child: ListenableBuilder(
            listenable: favorites,
            builder: (context, _) => favorites.isFavorite(recipe)
                ? const _InfoBox(value: 'Salva', label: 'nos favoritos')
                : const _InfoBox(value: 'Não salva', label: 'toque no ♡'),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String value;
  final String label;

  const _InfoBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(color: AppColors.text),
          ),
        ],
      ),
    );
  }
}

// Item da lista de ingredientes: "• Massa de pizza"
class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

// Passo numerado do modo de preparo: (1) Preaqueça o forno...
class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.primary,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

// Texto pequeno e cinza para avisos.
class _Missing extends StatelessWidget {
  final String text;

  const _Missing(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: AppColors.text),
    );
  }
}
