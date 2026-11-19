import 'package:flutter/material.dart';

import 'models/menu_item.dart';
import 'pages/item_detail_page.dart';
import 'pages/main_page.dart';
import 'pages/order_sent_page.dart';
import 'pages/search_results_page.dart';

// Todas as navegações do app ficam definidas aqui.
//
// /                -> MainPage (abas Cardápio e Pedido)
// /pesquisa        -> SearchResultsPage (recebe o termo pesquisado)
// /prato           -> ItemDetailPage (recebe o MenuItem)
// /pedido-enviado  -> OrderSentPage
class AppRoutes {
  static const home = '/';
  static const search = '/pesquisa';
  static const detail = '/prato';
  static const orderSent = '/pedido-enviado';

  static Route<dynamic> generate(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      search => SearchResultsPage(term: settings.arguments! as String),
      detail => ItemDetailPage(item: settings.arguments! as MenuItem),
      orderSent => const OrderSentPage(),
      _ => const MainPage(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
