import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

// Favoritos da sessão (RF05). Ficam só na memória.
//
// É a ÚNICA fonte de verdade: lista, pesquisa, detalhes e a aba Favoritos
// leem e alteram este mesmo objeto. Quando ele muda, avisa (notifyListeners)
// e todas as telas que estão "ouvindo" se redesenham.
class FavoritesController extends ChangeNotifier {
  // Map por id: a mesma receita nunca entra duas vezes (sem duplicatas).
  final Map<int, Recipe> _recipes = {};

  List<Recipe> get recipes => List.unmodifiable(_recipes.values);
  bool get isEmpty => _recipes.isEmpty;
  int get count => _recipes.length;

  bool isFavorite(Recipe recipe) => _recipes.containsKey(recipe.id);

  void toggle(Recipe recipe) {
    if (isFavorite(recipe)) {
      _recipes.remove(recipe.id);
    } else {
      _recipes[recipe.id] = recipe;
    }
    notifyListeners();
  }

  void clear() {
    _recipes.clear();
    notifyListeners();
  }
}

// Instância única compartilhada por todas as telas.
final favorites = FavoritesController();
