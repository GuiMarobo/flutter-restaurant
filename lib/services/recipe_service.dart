import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import 'api_exception.dart';

// Toda a comunicação com a API DummyJSON Recipes fica aqui.
// Documentação: https://dummyjson.com/docs/recipes
//
// Decisão sobre os detalhes (seção 4 do enunciado):
// a listagem e a pesquisa já devolvem o objeto COMPLETO de cada receita
// (ingredientes, instruções, tempos...). Por isso a tela de detalhes
// reaproveita esse objeto e não faz uma nova chamada a /recipes/{id}.
class RecipeService {
  static const _host = 'dummyjson.com';
  static const _timeout = Duration(seconds: 10);

  // Cliente HTTP. Nos testes ele é trocado por um cliente falso (MockClient).
  static http.Client client = http.Client();

  // Liga/desliga a simulação de "sem internet" (útil para demonstrar o RF07).
  static final simulateOffline = ValueNotifier<bool>(false);

  // GET /recipes?limit=0 -> todas as receitas (RF01 / RF02)
  static Future<List<Recipe>> fetchRecipes() {
    return _getRecipes(Uri.https(_host, '/recipes', {'limit': '0'}));
  }

  // GET /recipes/search?q=termo -> pesquisa remota pelo nome (RF03)
  static Future<List<Recipe>> searchRecipes(String term) {
    return _getRecipes(Uri.https(_host, '/recipes/search', {'q': term}));
  }

  // Faz o GET, confere o status e valida o JSON ANTES de devolver os dados.
  static Future<List<Recipe>> _getRecipes(Uri url) async {
    final http.Response response;
    try {
      if (simulateOffline.value) {
        throw const ApiException(ApiErrorType.network);
      }
      response = await client.get(url).timeout(_timeout);
    } on ApiException {
      rethrow;
    } on Exception {
      // SocketException, ClientException, TimeoutException...
      throw const ApiException(ApiErrorType.network);
    }

    // 1) Status: só 200 é sucesso
    if (response.statusCode != 200) {
      throw ApiException(ApiErrorType.status, statusCode: response.statusCode);
    }

    // 2) Corpo: precisa ser {"recipes": [ {...}, {...} ]}
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is! Map<String, dynamic> || body['recipes'] is! List) {
        throw const FormatException('Campo "recipes" ausente');
      }
      return (body['recipes'] as List)
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } on Object {
      // FormatException, TypeError (item que não é um objeto)...
      throw const ApiException(ApiErrorType.format);
    }
  }
}
