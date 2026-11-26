const searchErrorMessage = 'Escreva o nome de uma receita.';

String normalizeQuery(String text) =>
    text.trim().replaceAll(RegExp(r'\s+'), ' ');

String? validateQuery(String? text) =>
    normalizeQuery(text ?? '').isEmpty ? searchErrorMessage : null;
