import 'package:flutter/material.dart';
import 'package:global/models/cart_item.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final ValueNotifier<List<CartItem>> cartItemsNotifier =
      ValueNotifier<List<CartItem>>([]);

  List<CartItem> get items => cartItemsNotifier.value;

  int get totalItemsCount => items.length;

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalItemPrice);
  }

  void clearCart() {
    cartItemsNotifier.value = [];
  }
}
