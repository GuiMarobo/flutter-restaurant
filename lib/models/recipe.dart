class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final String? image;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final num? rating;
  final List<String> mealType;
  final String? cuisine;
  final String? difficulty;

  const Recipe({
    required this.id,
    required this.name,
    this.ingredients = const [],
    this.instructions = const [],
    this.image,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.rating,
    this.mealType = const [],
    this.cuisine,
    this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int) {
      throw const FormatException('Receita sem id válido');
    }

    final name = _readText(json['name']);

    return Recipe(
      id: id,
      name: name ?? 'Receita sem nome',
      ingredients: _readTextList(json['ingredients']),
      instructions: _readTextList(json['instructions']),
      image: _readText(json['image']),
      prepTimeMinutes: _readPositiveInt(json['prepTimeMinutes']),
      cookTimeMinutes: _readPositiveInt(json['cookTimeMinutes']),
      servings: _readPositiveInt(json['servings']),
      rating: json['rating'] is num ? json['rating'] as num : null,
      mealType: _readTextList(json['mealType']),
      cuisine: _readText(json['cuisine']),
      difficulty: _readText(json['difficulty']),
    );
  }

  int? get totalMinutes {
    if (prepTimeMinutes == null || cookTimeMinutes == null) return null;
    return prepTimeMinutes! + cookTimeMinutes!;
  }

  static String? _readText(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  static List<String> _readTextList(Object? value) {
    if (value is String) {
      final text = _readText(value);
      return text == null ? const [] : [text];
    }
    if (value is! List) return const [];
    return value.map(_readText).whereType<String>().toList();
  }

  static int? _readPositiveInt(Object? value) {
    if (value is! num) return null;
    final number = value.round();
    return number > 0 ? number : null;
  }
}
