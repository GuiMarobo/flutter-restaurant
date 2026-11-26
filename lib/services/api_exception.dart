// Erros possíveis ao falar com a API (RF07 - Erros).
enum ApiErrorType {
  network, // sem internet, servidor fora do ar ou demorou demais
  status, // a API respondeu com código de erro (404, 500...)
  format, // a API respondeu, mas o corpo não é o JSON esperado
}

class ApiException implements Exception {
  final ApiErrorType type;
  final int? statusCode;

  const ApiException(this.type, {this.statusCode});

  // Mensagem em linguagem simples para mostrar na tela.
  String get message => switch (type) {
    ApiErrorType.network => 'Verifique sua conexão e tente novamente.',
    ApiErrorType.status =>
      'O servidor respondeu com erro ($statusCode). '
          'Tente novamente em instantes.',
    ApiErrorType.format =>
      'O servidor enviou dados em um formato inesperado. '
          'Tente novamente mais tarde.',
  };

  @override
  String toString() => 'ApiException($type, $statusCode)';
}
