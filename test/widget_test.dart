import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/services/recipe_service.dart';
import 'package:flutter_restaurant/state/app_tab.dart';
import 'package:flutter_restaurant/state/favorites_controller.dart';
import 'package:flutter_restaurant/utils/search_query.dart';

// Receitas falsas no mesmo formato da API DummyJSON.
final _pizza = {
  'id': 1,
  'name': 'Classic Margherita Pizza',
  'ingredients': ['Pizza dough', 'Tomato sauce'],
  'instructions': ['Preheat the oven.', 'Bake.'],
  'prepTimeMinutes': 20,
  'cookTimeMinutes': 15,
  'servings': 4,
  'difficulty': 'Easy',
  'rating': 4.6,
  'mealType': ['Dinner'],
};
final _salad = {'id': 2, 'name': 'Greek Salad', 'rating': 4};

// API falsa: lista, pesquisa e um modo "sem internet".
bool _offline = false;
final _fakeApi = MockClient((request) async {
  if (_offline) throw http.ClientException('offline');
  final all = [_pizza, _salad];
  if (request.url.path == '/recipes/search') {
    final q = request.url.queryParameters['q']!.toLowerCase();
    final found = all
        .where((r) => (r['name'] as String).toLowerCase().contains(q))
        .toList();
    return http.Response(jsonEncode({'recipes': found}), 200);
  }
  return http.Response(jsonEncode({'recipes': all}), 200);
});

void main() {
  setUp(() {
    _offline = false;
    favorites.clear();
    selectedTab.value = AppTab.explore;
    RecipeService.client = _fakeApi;
  });

  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340); // celular 360x780
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SaboreApp());
  }

  Future<void> searchFor(WidgetTester tester, String text) async {
    await tester.tap(find.text('Buscar receitas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('searchField')), text);
    await tester.tap(find.widgetWithText(FilledButton, 'Pesquisar'));
    await tester.pumpAndSettle();
  }

  testWidgets('RF01/RF02/RF06: carrega e mostra a lista', (tester) async {
    await openApp(tester);
    expect(find.text('Carregando receitas…'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Saborê'), findsOneWidget);
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
    expect(find.text('35 min  •  Fácil'), findsOneWidget);
    expect(find.text('Greek Salad'), findsOneWidget);
  });

  testWidgets('RF07: erro de rede e tentar novamente', (tester) async {
    _offline = true;
    await openApp(tester);
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar as receitas.'), findsOneWidget);

    _offline = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
  });

  testWidgets('RF03: recusa pesquisa vazia', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    await searchFor(tester, '   ');

    expect(find.text(searchErrorMessage), findsOneWidget);
    expect(find.text('Qual receita você procura?'), findsOneWidget);
  });

  testWidgets('RF03/RF09: pesquisa, abre detalhe, volta e limpa', (
    tester,
  ) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    await searchFor(tester, '  margherita ');

    expect(find.text('Resultados para “margherita”'), findsOneWidget);
    expect(find.text('Greek Salad'), findsNothing);

    // Abre o detalhe (RF04)
    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Ingredientes'), findsOneWidget);
    expect(find.text('Pizza dough'), findsOneWidget);
    expect(find.text('35 min'), findsOneWidget);
    // Conteúdo longo: rola até o passo de preparo
    await tester.scrollUntilVisible(find.text('Preheat the oven.'), 200);
    expect(find.text('Preheat the oven.'), findsOneWidget);

    // Volta: a pesquisa continua lá (RF09)
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Resultados para “margherita”'), findsOneWidget);

    await tester.tap(find.text('Limpar pesquisa'));
    await tester.pumpAndSettle();
    expect(find.text('Qual receita você procura?'), findsOneWidget);
  });

  testWidgets('RF08: pesquisa sem resultados', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    await searchFor(tester, 'zzzz987');

    expect(find.text('Nenhum resultado'), findsOneWidget);
    await tester.tap(find.text('Ver todas as receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas disponíveis'), findsOneWidget);
  });

  testWidgets('RF05/RF08: favoritar e desfavoritar', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();

    // Favoritos vazio
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito'), findsOneWidget);

    // Volta e favorita a pizza
    await tester.tap(find.text('Explorar receitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Adicionar aos favoritos').first);
    await tester.pump();
    expect(favorites.count, 1);

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas salvas nesta sessão.'), findsOneWidget);
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);

    // Toque no coração remove
    await tester.tap(find.byTooltip('Remover dos favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito'), findsOneWidget);
  });
}
