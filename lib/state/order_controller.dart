import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';

// Guarda o pedido da mesa e avisa as telas quando ele muda.
class OrderController extends ChangeNotifier {
  final List<MenuItem> _items = [];

  List<MenuItem> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get total => _items.fold(0, (sum, i) => sum + i.price);

  void add(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Um único pedido compartilhado por todas as telas do app.
final order = OrderController();
