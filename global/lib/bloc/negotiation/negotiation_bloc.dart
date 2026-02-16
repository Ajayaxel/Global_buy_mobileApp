import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/negotiation/negotiation_event.dart';
import 'package:global/bloc/negotiation/negotiation_state.dart';
import 'package:global/repositories/negotiation_repository.dart';

class NegotiationBloc extends Bloc<NegotiationEvent, NegotiationState> {
  final NegotiationRepository negotiationRepository;

  NegotiationBloc({required this.negotiationRepository})
    : super(NegotiationInitial()) {
    on<AddNegotiationRequested>(_onAddNegotiationRequested);
  }

  Future<void> _onAddNegotiationRequested(
    AddNegotiationRequested event,
    Emitter<NegotiationState> emit,
  ) async {
    emit(NegotiationLoading());
    try {
      final response = await negotiationRepository.addNegotiation(
        cartId: event.cartId,
        negotiationPrice: event.negotiationPrice,
      );
      emit(
        NegotiationSuccess(
          message: response.message,
          negotiation: response.negotiation,
        ),
      );
    } catch (e) {
      emit(NegotiationFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
