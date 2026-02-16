import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/order/order_detail_event.dart';
import 'package:global/bloc/order/order_detail_state.dart';
import 'package:global/repositories/order_repository.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final OrderRepository orderRepository;

  OrderDetailBloc({required this.orderRepository})
    : super(OrderDetailInitial()) {
    on<FetchOrderDetails>(_onFetchOrderDetails);
  }

  Future<void> _onFetchOrderDetails(
    FetchOrderDetails event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(OrderDetailLoading());
    try {
      final order = await orderRepository.getOrderDetails(event.orderId);
      emit(OrderDetailLoaded(order));
    } catch (e) {
      emit(OrderDetailError(e.toString()));
    }
  }
}
