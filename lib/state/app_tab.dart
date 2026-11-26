import 'package:flutter/foundation.dart';

final selectedTab = ValueNotifier<int>(AppTab.home);

class AppTab {
  static const home = 0;
  static const favorites = 1;
}
