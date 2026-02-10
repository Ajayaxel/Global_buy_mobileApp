import 'package:equatable/equatable.dart';
import 'package:global/models/buyer_documents_model.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentSuccess extends DocumentState {
  final String message;

  const DocumentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DocumentFailure extends DocumentState {
  final String error;

  const DocumentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class DocumentFetchSuccess extends DocumentState {
  final BuyerDocuments documents;

  const DocumentFetchSuccess(this.documents);

  @override
  List<Object?> get props => [documents];
}
