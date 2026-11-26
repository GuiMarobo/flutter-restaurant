import 'package:flutter/foundation.dart';

// Aba selecionada na barra inferior: 0 = Explorar, 1 = Favoritos.
// Fica fora da MainPage para que a tela de pesquisa também consiga trocar de aba.
final selectedTab = ValueNotifier<int>(AppTab.explore);

class AppTab {
  static const explore = 0;
  static const favorites = 1;
}
