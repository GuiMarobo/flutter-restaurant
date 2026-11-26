import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../state/app_tab.dart';

// Barra inferior com as abas Início e Favoritos.
// Usada na MainPage e também na tela de pesquisa.
class AppBottomBar extends StatelessWidget {
  // true quando a barra está numa tela empilhada (pesquisa):
  // ao trocar de aba, volta primeiro para a tela principal.
  final bool popToHome;

  const AppBottomBar({super.key, this.popToHome = false});

  void _select(BuildContext context, int tab) {
    if (popToHome) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    selectedTab.value = tab;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedTab,
      builder: (context, tab, _) => NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) => _select(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border, color: AppColors.muted),
            selectedIcon: Icon(Icons.favorite, color: AppColors.primary),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
