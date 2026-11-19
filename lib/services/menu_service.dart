import 'package:flutter/foundation.dart';

import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../utils/search_query.dart';

// Erro lançado quando o app está "sem conexão".
class ConnectionException implements Exception {
  const ConnectionException();
}

// Simula um servidor: os dados ainda são provisórios (menu_data.dart),
// mas a resposta demora um pouco para mostrar a tela de carregamento.
class MenuService {
  // Liga/desliga a simulação de falta de internet (menu do AppBar).
  static final offline = ValueNotifier<bool>(false);

  static const _delay = Duration(milliseconds: 800);

  static Future<List<MenuItem>> fetchMenu() async {
    await Future.delayed(_delay);
    if (offline.value) throw const ConnectionException();
    return menuItems;
  }

  static Future<List<MenuItem>> search(String term) async {
    final items = await fetchMenu();
    return items.where((i) => matchesQuery(i.name, term)).toList();
  }
}
