import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../pages/main_page.dart';
import '../pages/recipe_detail_page.dart';
import '../pages/search_page.dart';

// Todas as rotas do app ficam definidas aqui (RF09 - Navegação).
//
// /          -> MainPage (abas Explorar e Favoritos)
// /pesquisa  -> SearchPage (recebe o termo digitado na tela principal, ou null)
// /receita   -> RecipeDetailPage (recebe a Recipe selecionada)
class AppRoutes {
  static const home = '/';
  static const search = '/pesquisa';
  static const detail = '/receita';

  static Route<dynamic> generate(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      search => SearchPage(initialTerm: settings.arguments as String?),
      detail => RecipeDetailPage(recipe: settings.arguments! as Recipe),
      _ => const MainPage(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
