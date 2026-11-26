// Modelo de uma receita vinda da API DummyJSON.
//
// Cada campo é lido com cuidado (seção 4 do enunciado):
// - nada é "inventado": se a API não mandar um valor, ele fica null/vazio;
// - os tipos são conferidos antes de usar (ex.: rating pode vir int ou double).
class Recipe {
  final int id; // identidade estável: usada na seleção e nos favoritos
  final String name;
  final List<String> ingredients;
  final List<String> instructions; // a ordem da lista é a ordem dos passos
  final String? image;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final num? rating; // num aceita 4 e 4.6
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

  // Converte o JSON da API em Recipe.
  // Lança FormatException se faltar o mínimo necessário (o id).
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int) {
      throw const FormatException('Receita sem id válido');
    }

    final name = _readText(json['name']);

    return Recipe(
      id: id,
      name: name ?? 'Receita sem nome', // prevê ausência inesperada do nome
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

  // Tempo total só existe quando os DOIS tempos foram informados.
  // Não troca ausência por zero.
  int? get totalMinutes {
    if (prepTimeMinutes == null || cookTimeMinutes == null) return null;
    return prepTimeMinutes! + cookTimeMinutes!;
  }

  // ---- Funções auxiliares de leitura do JSON ----

  // Texto não vazio, ou null.
  static String? _readText(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  // Lista de textos. Aceita também uma String única (ex.: mealType: "Dinner").
  static List<String> _readTextList(Object? value) {
    if (value is String) {
      final text = _readText(value);
      return text == null ? const [] : [text];
    }
    if (value is! List) return const [];
    return value.map(_readText).whereType<String>().toList();
  }

  // Número inteiro maior que zero. Aceita 20 ou 20.0; recusa texto e negativos.
  static int? _readPositiveInt(Object? value) {
    if (value is! num) return null;
    final number = value.round();
    return number > 0 ? number : null;
  }
}
