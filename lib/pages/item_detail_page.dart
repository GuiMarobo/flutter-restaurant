import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../state/order_controller.dart';

// Detalhes do prato: descrição, quantidade, observações e botão de adicionar.
class ItemDetailPage extends StatefulWidget {
  final MenuItem item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _quantity = 1;

  void _addToOrder() {
    for (var i = 0; i < _quantity; i++) {
      order.add(widget.item);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity× ${widget.item.name} adicionado ao pedido'),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop(); // volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(item.category)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(item.icon, size: 96, color: colors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            item.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatPrice(item.price),
            style: textTheme.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text('Descrição', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(item.description, style: textTheme.bodyLarge),
          const SizedBox(height: 24),
          // Seletor de quantidade
          Row(
            children: [
              Text('Quantidade', style: textTheme.titleMedium),
              const Spacer(),
              IconButton.outlined(
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                icon: const Icon(Icons.remove),
                tooltip: 'Diminuir',
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                ),
              ),
              IconButton.outlined(
                onPressed: () => setState(() => _quantity++),
                icon: const Icon(Icons.add),
                tooltip: 'Aumentar',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Observações', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ex.: sem cebola, ponto da carne...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _addToOrder,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              'Adicionar ao pedido · ${formatPrice(item.price * _quantity)}',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
