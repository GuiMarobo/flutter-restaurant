import '../models/recipe.dart';

String? formatRating(num? rating) {
  if (rating == null) return null;
  return rating.toStringAsFixed(1).replaceAll('.', ',');
}

String? formatDifficulty(String? difficulty) => switch (difficulty) {
  'Easy' => 'Fácil',
  'Medium' => 'Média',
  'Hard' => 'Difícil',
  _ => difficulty,
};

String formatTime(Recipe recipe) {
  if (recipe.totalMinutes != null) return '${recipe.totalMinutes} min';
  if (recipe.prepTimeMinutes != null) {
    return '${recipe.prepTimeMinutes} min de preparo';
  }
  if (recipe.cookTimeMinutes != null) {
    return '${recipe.cookTimeMinutes} min de cozimento';
  }
  return 'Tempo não informado';
}

String countRecipes(int count) =>
    '$count ${count == 1 ? 'receita' : 'receitas'}';
