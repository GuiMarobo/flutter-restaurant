import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../routes.dart';
import '../state/order_controller.dart';
import '../widgets/state_view.dart';

// Aba Pedido: itens escolhidos, total e envio para a cozinha.
class OrderPage extends StatelessWidget {
  final VoidCallback onBackToMenu;

  const OrderPage({super.key, required this.onBackToMenu});

  void _sendOrder(BuildContext context) {
    order.clear();
    // Navega para a confirmação do pedido
    Navigator.of(context).pushNamed(AppRoutes.orderSent);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // ListenableBuilder redesenha a tela sempre que o pedido muda
      body: ListenableBuilder(
        listenable: order,
        builder: (context, _) {
          if (order.isEmpty) {
            return StateView(
              icon: Icons.receipt_long,
              title: 'Seu pedido está vazio',
              message: 'Escolha um prato no cardápio para começar.',
              actionLabel: 'Ver cardápio',
              onAction: onBackToMenu,
            );
          }
          final items = order.items;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: colors.primaryContainer,
                        child: Icon(item.icon, color: colors.primary),
                      ),
                      title: Text(item.name),
                      subtitle: Text(formatPrice(item.price)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Remover',
                        onPressed: () => order.removeAt(index),
                      ),
                    );
                  },
                ),
              ),
              // Total e botão de envio
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 12,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: textTheme.titleLarge),
                        Text(
                          formatPrice(order.total),
                          style: textTheme.titleLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _sendOrder(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Enviar pedido'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
