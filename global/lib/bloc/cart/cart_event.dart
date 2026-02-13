import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;
  final double price;

  const AddToCartEvent({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object> get props => [productId, quantity, price];
}

class FetchCartItems extends CartEvent {}

class RemoveFromCartEvent extends CartEvent {
  final int cartItemId;

  const RemoveFromCartEvent(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final int cartItemId;
  final int quantity;

  const UpdateCartItemQuantity({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object> get props => [cartItemId, quantity];
}

class BuyNowEvent extends CartEvent {}
