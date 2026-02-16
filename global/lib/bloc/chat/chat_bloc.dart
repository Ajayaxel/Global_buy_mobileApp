import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/chat/chat_event.dart';
import 'package:global/bloc/chat/chat_state.dart';
import 'package:global/repositories/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<FetchChatListRequested>(_onFetchChatListRequested);
    on<FetchChatMessagesRequested>(_onFetchChatMessagesRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  Future<void> _onFetchChatListRequested(
    FetchChatListRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final suppliers = await chatRepository.getChatList();
      emit(ChatLoaded(suppliers));
    } catch (e) {
      emit(ChatFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchChatMessagesRequested(
    FetchChatMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessagesLoading());
    try {
      final messages = await chatRepository.getChatMessages(event.supplierId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessagesFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = await chatRepository.sendMessage(
        event.supplierId,
        event.message,
      );
      emit(MessageSentSuccess(message));
    } catch (e) {
      emit(MessageSentFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
