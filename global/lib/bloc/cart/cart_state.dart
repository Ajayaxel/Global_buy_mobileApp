import 'package:equatable/equatable.dart';
import 'package:global/models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CartSuccess extends CartState {
  final String message;

  const CartSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CartError extends CartState {
  final String error;

  const CartError(this.error);
  @override
  List<Object> get props => [error];
}
