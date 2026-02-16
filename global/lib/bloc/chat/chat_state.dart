import 'package:equatable/equatable.dart';
import 'package:global/models/chat_message_model.dart';
import 'package:global/models/chat_supplier_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatSupplier> suppliers;

  const ChatLoaded(this.suppliers);

  @override
  List<Object?> get props => [suppliers];
}

class ChatFailure extends ChatState {
  final String error;

  const ChatFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<ChatMessage> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesFailure extends ChatState {
  final String error;

  const MessagesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class MessageSentSuccess extends ChatState {
  final ChatMessage message;

  const MessageSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSentFailure extends ChatState {
  final String error;

  const MessageSentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
