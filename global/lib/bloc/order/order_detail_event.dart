import 'package:equatable/equatable.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderDetails extends OrderDetailEvent {
  final int orderId;

  const FetchOrderDetails(this.orderId);

  @override
  List<Object> get props => [orderId];
}
