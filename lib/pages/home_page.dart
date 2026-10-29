import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../widgets/menu_item_card.dart';
import 'item_detail_page.dart';
import 'order_page.dart';

// Tela principal: mostra o cardápio do restaurante.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = categories.first; // categoria selecionada nos chips
  final List<MenuItem> _order = []; // itens adicionados ao pedido

  // Filtra os itens do cardápio pela categoria escolhida
  List<MenuItem> get _filteredItems => _selectedCategory == 'Todos'
      ? menuItems
      : menuItems.where((i) => i.category == _selectedCategory).toList();

  double get _orderTotal => _order.fold(0, (sum, i) => sum + i.price);

  void _addToOrder(MenuItem item) {
    setState(() => _order.add(item));
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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cardápio Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Ícone do pedido com contador de itens
          IconButton(
            icon: Badge(
              isLabelVisible: _order.isNotEmpty,
              label: Text('${_order.length}'),
              child: const Icon(Icons.receipt_long),
            ),
            tooltip: 'Meu pedido',
            onPressed: _openOrder,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // alinha os filhos à esquerda
        children: [
          // Cabeçalho: boas-vindas, mesa e campo de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              spacing: 8, // espaçamento entre os itens da coluna
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo!',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 6,
                  children: [
                    Icon(Icons.table_restaurant,
                        size: 18, color: colors.primary),
                    Text(
                      'Mesa 05 · Escolha seu prato e faça o pedido',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar no cardápio...', // placeholder
                    prefixIcon: Icon(Icons.search, color: colors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    // borda quando o campo está selecionado
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Lista horizontal de categorias
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: category == _selectedCategory,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              _selectedCategory == 'Todos' ? 'Cardápio' : _selectedCategory,
              style: textTheme.titleLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Expanded ocupa todo o espaço restante com a lista de pratos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return MenuItemCard(
                  item: item,
                  onAdd: () => _addToOrder(item),
                  onTap: () => _openDetail(item),
                );
              },
            ),
          ),
          // Botão "Ver pedido" aparece só quando há itens no pedido
          if (_order.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity, // ocupa toda a largura da tela
                child: FilledButton(
                  onPressed: _openOrder,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Ver pedido (${_order.length}) · ${formatPrice(_orderTotal)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
      // Barra de navegação inferior: Cardápio e Pedido
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0, // 0 = Cardápio
        onDestinationSelected: (index) {
          if (index == 1) _openOrder();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Cardápio',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pedido',
          ),
        ],
      ),
    );
  }

  // Abre a tela de detalhes; se o usuário tocar em "Adicionar", entra no pedido
  Future<void> _openDetail(MenuItem item) async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ItemDetailPage(item: item)),
    );
    if (added == true) _addToOrder(item);
  }

  Future<void> _openOrder() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderPage(items: _order)),
    );
    setState(() {}); // atualiza o contador ao voltar do pedido
  }
}
