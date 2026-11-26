import 'package:flutter/material.dart';

import '../state/app_tab.dart';
import '../widgets/app_bottom_bar.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
