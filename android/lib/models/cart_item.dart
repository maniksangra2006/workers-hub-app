import 'service.dart';

class CartItem {
  final Service service;
  final int quantity;

  CartItem({
    required this.service,
    this.quantity = 1,
  });

  double get totalPrice => service.price * quantity;
}
