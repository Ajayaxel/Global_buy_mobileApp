import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class UploadDocumentsRequested extends DocumentEvent {
  final String governmentIdPath;
  final String businessLicensePath;
  final String proofOfAddressPath;

  const UploadDocumentsRequested({
    required this.governmentIdPath,
    required this.businessLicensePath,
    required this.proofOfAddressPath,
  });

  @override
  List<Object?> get props => [
    governmentIdPath,
    businessLicensePath,
    proofOfAddressPath,
  ];
}

class FetchDocumentsRequested extends DocumentEvent {}
