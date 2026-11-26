import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import 'api_exception.dart';

class RecipeService {
  static const _host = 'dummyjson.com';
  static const _timeout = Duration(seconds: 10);

  static http.Client client = http.Client();

  static final simulateOffline = ValueNotifier<bool>(false);

  static Future<List<Recipe>> fetchRecipes() {
    return _getRecipes(Uri.https(_host, '/recipes', {'limit': '0'}));
  }

  static Future<List<Recipe>> searchRecipes(String term) {
    return _getRecipes(Uri.https(_host, '/recipes/search', {'q': term}));
  }

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
      throw const ApiException(ApiErrorType.network);
    }

    if (response.statusCode != 200) {
      throw ApiException(ApiErrorType.status, statusCode: response.statusCode);
    }

    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is! Map<String, dynamic> || body['recipes'] is! List) {
        throw const FormatException('Campo "recipes" ausente');
      }
      return (body['recipes'] as List)
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const ApiException(ApiErrorType.format);
    }
  }
}
