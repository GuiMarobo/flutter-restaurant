enum ApiErrorType { network, status, format }

class ApiException implements Exception {
  final ApiErrorType type;
  final int? statusCode;

  const ApiException(this.type, {this.statusCode});

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
