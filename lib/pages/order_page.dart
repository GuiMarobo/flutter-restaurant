import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class OrderPage extends StatefulWidget {
  final List<MenuItem> items;

  const OrderPage({super.key, required this.items});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  double get _total => widget.items.fold(0, (sum, i) => sum + i.price);

  void _sendOrder() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, size: 48),
        title: const Text('Pedido enviado!'),
        content: const Text('Seu pedido foi enviado para a cozinha.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {
      setState(widget.items.clear);
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Pedido')),
      body: widget.items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long,
                      size: 64, color: colors.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('Seu pedido está vazio', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Adicione itens do cardápio',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final item = widget.items[index];
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
                    onPressed: () =>
                        setState(() => widget.items.removeAt(index)),
                  ),
                );
              },
            ),
      bottomNavigationBar: widget.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: textTheme.titleLarge),
                        Text(
                          formatPrice(_total),
                          style: textTheme.titleLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _sendOrder,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Enviar pedido'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
