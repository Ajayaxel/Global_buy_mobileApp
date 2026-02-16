import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchChatListRequested extends ChatEvent {}

class FetchChatMessagesRequested extends ChatEvent {
  final int supplierId;

  const FetchChatMessagesRequested(this.supplierId);

  @override
  List<Object?> get props => [supplierId];
}

class SendMessageRequested extends ChatEvent {
  final int supplierId;
  final String message;

  const SendMessageRequested(this.supplierId, this.message);

  @override
  List<Object?> get props => [supplierId, message];
}
