import 'package:equatable/equatable.dart';

abstract class NegotiationEvent extends Equatable {
  const NegotiationEvent();

  @override
  List<Object?> get props => [];
}

class AddNegotiationRequested extends NegotiationEvent {
  final int cartId;
  final String negotiationPrice;

  const AddNegotiationRequested({
    required this.cartId,
    required this.negotiationPrice,
  });

  @override
  List<Object?> get props => [cartId, negotiationPrice];
}
