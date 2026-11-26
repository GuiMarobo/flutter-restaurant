import '../models/recipe.dart';

// Funções que transformam os dados da receita em texto para a tela.

// 4.6 -> "4,6"   |   4 -> "4,0"   |   null -> null
String? formatRating(num? rating) {
  if (rating == null) return null;
  return rating.toStringAsFixed(1).replaceAll('.', ',');
}

// Easy -> Fácil. Valores desconhecidos aparecem como vieram da API.
String? formatDifficulty(String? difficulty) => switch (difficulty) {
  'Easy' => 'Fácil',
  'Medium' => 'Média',
  'Hard' => 'Difícil',
  _ => difficulty,
};

// Texto do tempo: total quando há os dois tempos, senão o que existir.
String formatTime(Recipe recipe) {
  if (recipe.totalMinutes != null) return '${recipe.totalMinutes} min';
  if (recipe.prepTimeMinutes != null) {
    return '${recipe.prepTimeMinutes} min de preparo';
  }
  if (recipe.cookTimeMinutes != null) {
    return '${recipe.cookTimeMinutes} min de cozimento';
  }
  return 'Tempo não informado'; // ausência NÃO vira "0 min"
}

// 1 -> "1 receita"   |   3 -> "3 receitas"
String countRecipes(int count) =>
    '$count ${count == 1 ? 'receita' : 'receitas'}';
