import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get count => _items.fold(0, (p, e) => p + e.qty);
  double get total => _items.fold(0.0, (p, e) => p + e.price * e.qty);

  void add(CartItem item) {
// simple merge by service+option
    final idx = _items.indexWhere((e) => e.service.id == item.service.id && e.option == item.option);
    if (idx >= 0) {
      final ex = _items[idx];
      _items[idx] = CartItem(service: ex.service, option: ex.option, qty: ex.qty + item.qty, price: ex.price);
    } else {
      _items.add(item);
    }
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