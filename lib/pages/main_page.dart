import 'package:flutter/material.dart';

import '../state/app_tab.dart';
import '../widgets/app_bottom_bar.dart';
import 'favorites_page.dart';
import 'home_page.dart';

// Tela base com a barra inferior: abas Início e Favoritos.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Escuta a aba selecionada e mostra a página correspondente.
      // IndexedStack mantém as duas abas vivas: a lista não recarrega
      // e a posição de rolagem é conservada ao trocar de aba (RF09).
      body: ValueListenableBuilder(
        valueListenable: selectedTab,
        builder: (context, tab, _) => IndexedStack(
          index: tab,
          children: const [HomePage(), FavoritesPage()],
        ),
      ),
      bottomNavigationBar: const AppBottomBar(),
    );
  }
}
