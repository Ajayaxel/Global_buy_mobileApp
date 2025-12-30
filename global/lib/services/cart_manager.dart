import 'package:flutter/material.dart';
import 'package:global/models/cart_item.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final ValueNotifier<List<CartItem>> cartItemsNotifier =
      ValueNotifier<List<CartItem>>([]);

  List<CartItem> get items => cartItemsNotifier.value;

  void addItem(CartItem item) {
    final currentItems = List<CartItem>.from(cartItemsNotifier.value);
    // Check if item already exists
    final index = currentItems.indexWhere(
      (i) => i.name == item.name && i.grade == item.grade,
    );
    if (index != -1) {
      currentItems[index].quantity += item.quantity;
    } else {
      currentItems.add(item);
    }
    cartItemsNotifier.value = currentItems;
  }

  void removeItem(CartItem item) {
    final currentItems = List<CartItem>.from(cartItemsNotifier.value);
    currentItems.removeWhere(
      (i) => i.name == item.name && i.grade == item.grade,
    );
    cartItemsNotifier.value = currentItems;
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
      return;
    }
    final currentItems = List<CartItem>.from(cartItemsNotifier.value);
    final index = currentItems.indexWhere(
      (i) => i.name == item.name && i.grade == item.grade,
    );
    if (index != -1) {
      currentItems[index].quantity = newQuantity;
      cartItemsNotifier.value = currentItems;
    }
  }

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalItemPrice);
  }

  void clearCart() {
    cartItemsNotifier.value = [];
  }
}
