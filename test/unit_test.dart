import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_restaurant/models/recipe.dart';
import 'package:flutter_restaurant/services/api_exception.dart';
import 'package:flutter_restaurant/services/recipe_service.dart';
import 'package:flutter_restaurant/state/favorites_controller.dart';
import 'package:flutter_restaurant/utils/formatters.dart';
import 'package:flutter_restaurant/utils/search_query.dart';

void main() {
  group('Pesquisa (RF03)', () {
    test('remove espaços externos e repetidos', () {
      expect(normalizeQuery('  margherita   pizza '), 'margherita pizza');
    });

    test('recusa consulta vazia ou só com espaços', () {
      expect(validateQuery(''), searchErrorMessage);
      expect(validateQuery('    '), searchErrorMessage);
      expect(validateQuery(null), searchErrorMessage);
      expect(validateQuery(' pizza '), isNull);
    });
  });

  group('Recipe.fromJson', () {
    test('lê os campos da API', () {
      final recipe = Recipe.fromJson({
        'id': 1,
        'name': 'Classic Margherita Pizza',
        'ingredients': ['Pizza dough', 'Tomato sauce'],
        'instructions': ['Preheat', 'Bake'],
        'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
        'prepTimeMinutes': 20,
        'cookTimeMinutes': 15,
        'servings': 4,
        'rating': 4.6,
        'mealType': ['Dinner'],
        'difficulty': 'Easy',
      });
      expect(recipe.totalMinutes, 35);
      expect(recipe.instructions, ['Preheat', 'Bake']);
      expect(formatRating(recipe.rating), '4,6');
      expect(formatDifficulty(recipe.difficulty), 'Fácil');
    });

    test('rating inteiro e mealType como String única', () {
      final recipe = Recipe.fromJson({
        'id': 2,
        'name': 'X',
        'rating': 5,
        'mealType': 'Lunch',
      });
      expect(formatRating(recipe.rating), '5,0');
      expect(recipe.mealType, ['Lunch']);
    });

    test('campos ausentes não viram zero', () {
      final recipe = Recipe.fromJson({'id': 3, 'prepTimeMinutes': 10});
      expect(recipe.name, 'Receita sem nome');
      expect(recipe.ingredients, isEmpty);
      expect(recipe.image, isNull);
      expect(recipe.servings, isNull);
      expect(recipe.totalMinutes, isNull);
      expect(formatTime(recipe), '10 min de preparo');
    });

    test('sem id é um formato inválido', () {
      expect(() => Recipe.fromJson({'name': 'X'}), throwsFormatException);
    });
  });

  group('RecipeService (RF07)', () {
    tearDown(() => RecipeService.client = http.Client());

    Future<ApiErrorType> errorFor(MockClient client) async {
      RecipeService.client = client;
      try {
        await RecipeService.fetchRecipes();
      } on ApiException catch (e) {
        return e.type;
      }
      fail('Deveria ter lançado ApiException');
    }

    test('status de erro', () async {
      final type = await errorFor(
        MockClient((_) async => http.Response('', 500)),
      );
      expect(type, ApiErrorType.status);
    });

    test('corpo incompatível', () async {
      final type = await errorFor(
        MockClient((_) async => http.Response('{"foo": 1}', 200)),
      );
      expect(type, ApiErrorType.format);
    });

    test('falha de rede', () async {
      final type = await errorFor(
        MockClient((_) async => throw http.ClientException('offline')),
      );
      expect(type, ApiErrorType.network);
    });

    test('pesquisa usa o endpoint remoto com o termo', () async {
      Uri? called;
      RecipeService.client = MockClient((request) async {
        called = request.url;
        return http.Response(jsonEncode({'recipes': []}), 200);
      });
      await RecipeService.searchRecipes('pizza');
      expect(called.toString(), 'https://dummyjson.com/recipes/search?q=pizza');
    });
  });

  test('Favoritos não aceitam duplicatas (RF05)', () {
    final controller = FavoritesController();
    const recipe = Recipe(id: 1, name: 'A');
    controller.toggle(recipe);
    controller.toggle(const Recipe(id: 2, name: 'B'));
    expect(controller.count, 2);
    controller.toggle(recipe);
    expect(controller.count, 1);
    expect(controller.isFavorite(recipe), isFalse);
  });
}
