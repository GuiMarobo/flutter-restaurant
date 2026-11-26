// Regras da pesquisa pelo nome da receita (RF03).

const searchErrorMessage = 'Digite um nome para pesquisar.';

// Tira os espaços do começo e do fim e junta espaços repetidos no meio.
// Ex.: "  margherita   pizza " -> "margherita pizza"
String normalizeQuery(String text) =>
    text.trim().replaceAll(RegExp(r'\s+'), ' ');

// Retorna a mensagem de erro, ou null se a consulta for válida.
// Recusa consulta vazia ou só com espaços.
String? validateQuery(String? text) =>
    normalizeQuery(text ?? '').isEmpty ? searchErrorMessage : null;
