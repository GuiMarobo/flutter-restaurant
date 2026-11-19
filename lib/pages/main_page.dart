import 'package:flutter/material.dart';

import '../state/order_controller.dart';
import 'menu_page.dart';
import 'order_page.dart';

// Tela base com a barra de navegação inferior: Cardápio e Pedido.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tab = 0; // 0 = Cardápio, 1 = Pedido

  void _goToTab(int index) => setState(() => _tab = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantém as duas abas vivas (não perde a rolagem/busca)
      body: IndexedStack(
        index: _tab,
        children: [
          MenuPage(onOpenOrder: () => _goToTab(1)),
          OrderPage(onBackToMenu: () => _goToTab(0)),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: order, // atualiza o contador do pedido
        builder: (context, _) => NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: _goToTab,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Cardápio',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: !order.isEmpty,
                label: Text('${order.count}'),
                child: const Icon(Icons.receipt_long_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: !order.isEmpty,
                label: Text('${order.count}'),
                child: const Icon(Icons.receipt_long),
              ),
              label: 'Pedido',
            ),
          ],
        ),
      ),
    );
  }
}
