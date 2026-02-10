import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/document/document_event.dart';
import 'package:global/bloc/document/document_state.dart';
import 'package:global/repositories/auth_repository.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final AuthRepository authRepository;

  DocumentBloc({required this.authRepository}) : super(DocumentInitial()) {
    on<UploadDocumentsRequested>(_onUploadDocumentsRequested);
    on<FetchDocumentsRequested>(_onFetchDocumentsRequested);
  }

  Future<void> _onUploadDocumentsRequested(
    UploadDocumentsRequested event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final message = await authRepository.uploadDocuments(
        governmentIdPath: event.governmentIdPath,
        businessLicensePath: event.businessLicensePath,
        proofOfAddressPath: event.proofOfAddressPath,
      );
      emit(DocumentSuccess(message));
    } catch (e) {
      emit(DocumentFailure(e.toString()));
    }
  }

  Future<void> _onFetchDocumentsRequested(
    FetchDocumentsRequested event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await authRepository.fetchDocuments();
      emit(DocumentFetchSuccess(documents));
    } catch (e) {
      emit(DocumentFailure(e.toString()));
    }
  }
}
