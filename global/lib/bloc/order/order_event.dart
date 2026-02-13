import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {}

class FetchOrderDetails extends OrderEvent {
  final int orderId;

  const FetchOrderDetails(this.orderId);

  @override
  List<Object> get props => [orderId];
}
