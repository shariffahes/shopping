import 'package:flutter/material.dart';
import 'package:shopping/providers/product.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double priceOfProduct;

  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.priceOfProduct});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get itemsInTheCart {
    return _items;
  }

  CartItem getCartItemWith({required String id}) {
    return _items[id]!;
  }

  void addItem(String productId, String name, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (item) => CartItem(
              id: item.id,
              name: item.name,
              quantity: item.quantity + 1,
              priceOfProduct: item.priceOfProduct));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              name: name,
              quantity: 1,
              priceOfProduct: price));
    }
    notifyListeners();
  }

  double get totalPrice {
    double sum = 0.0;

    _items.forEach((productId, item) {
      sum += (item.priceOfProduct * item.quantity);
    });

    return sum;
  }

  int productCount() {
    return _items.length;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void undoItem(String id) {
    if (_items[id]!.quantity > 1) {
      _items.update(
          id,
          (product) => CartItem(
              id: product.id,
              name: product.name,
              quantity: product.quantity - 1,
              priceOfProduct: product.priceOfProduct));
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
