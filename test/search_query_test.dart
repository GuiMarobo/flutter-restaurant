import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_restaurant/utils/search_query.dart';

void main() {
  test('remove espaços nas pontas e repetidos no meio', () {
    expect(normalizeQuery('  filé   à  parmegiana '), 'filé à parmegiana');
  });

  test('recusa consulta vazia ou só com espaços', () {
    expect(validateQuery(''), searchErrorMessage);
    expect(validateQuery('    '), searchErrorMessage);
    expect(validateQuery(null), searchErrorMessage);
    expect(validateQuery(' pudim '), isNull);
  });

  test('compara sem maiúsculas e sem acentos', () {
    expect(matchesQuery('Filé à Parmegiana', 'file a parm'), isTrue);
    expect(matchesQuery('Pudim', 'risoto'), isFalse);
  });
}
