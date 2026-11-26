import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

class FavoritesController extends ChangeNotifier {
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

final favorites = FavoritesController();
