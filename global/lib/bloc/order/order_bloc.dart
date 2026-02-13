import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/order/order_event.dart';
import 'package:global/bloc/order/order_state.dart';
import 'package:global/repositories/order_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<FetchOrderDetails>(_onFetchOrderDetails);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onFetchOrderDetails(
    FetchOrderDetails event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final order = await orderRepository.getOrderDetails(event.orderId);
      emit(OrderDetailLoaded(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
