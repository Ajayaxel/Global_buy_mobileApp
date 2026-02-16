import 'package:equatable/equatable.dart';
import 'package:global/models/negotiation_model.dart';

abstract class NegotiationState extends Equatable {
  const NegotiationState();

  @override
  List<Object?> get props => [];
}

class NegotiationInitial extends NegotiationState {}

class NegotiationLoading extends NegotiationState {}

class NegotiationSuccess extends NegotiationState {
  final String message;
  final Negotiation negotiation;

  const NegotiationSuccess({required this.message, required this.negotiation});

  @override
  List<Object?> get props => [message, negotiation];
}

class NegotiationFailure extends NegotiationState {
  final String error;

  const NegotiationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
