import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../routes.dart';
import '../state/order_controller.dart';
import 'menu_item_card.dart';

// Lista de pratos usada no Cardápio e nos Resultados da pesquisa.
class MenuList extends StatelessWidget {
  final List<MenuItem> items;

  const MenuList({super.key, required this.items});

  void _add(BuildContext context, MenuItem item) {
    order.add(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} adicionado ao pedido'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuItemCard(
          item: item,
          onAdd: () => _add(context, item),
          // Navega para os detalhes do prato
          onTap: () =>
              Navigator.of(context)
                  .pushNamed(AppRoutes.detail, arguments: item),
        );
      },
    );
  }
}
