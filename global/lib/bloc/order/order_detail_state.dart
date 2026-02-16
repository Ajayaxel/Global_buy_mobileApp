import 'package:equatable/equatable.dart';
import 'package:global/models/order_model.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderModel order;

  const OrderDetailLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrderDetailError extends OrderDetailState {
  final String message;

  const OrderDetailError(this.message);

  @override
  List<Object> get props => [message];
}
