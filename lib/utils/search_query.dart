// Regras da pesquisa pelo nome do prato.

const searchErrorMessage =
    'Digite o nome de um prato (ex.: Pudim). '
    'O campo não pode ficar vazio nem só com espaços.';

// Tira os espaços do começo e do fim e junta espaços repetidos no meio.
// Ex.: "  filé   à  parmegiana " -> "filé à parmegiana"
String normalizeQuery(String text) =>
    text.trim().replaceAll(RegExp(r'\s+'), ' ');

// Retorna a mensagem de erro, ou null se a consulta for válida.
String? validateQuery(String? text) =>
    normalizeQuery(text ?? '').isEmpty ? searchErrorMessage : null;

// Compara sem diferenciar maiúsculas/minúsculas nem acentos.
bool matchesQuery(String name, String query) =>
    _simplify(name).contains(_simplify(query));

String _simplify(String text) {
  const withAccents = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const withoutAccents = 'aaaaaeeeeiiiiooooouuuuc';
  final buffer = StringBuffer();
  for (final char in text.toLowerCase().split('')) {
    final index = withAccents.indexOf(char);
    buffer.write(index == -1 ? char : withoutAccents[index]);
  }
  return buffer.toString();
}
