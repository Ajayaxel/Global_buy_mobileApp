import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/chat/chat_bloc.dart';
import 'package:global/bloc/chat/chat_event.dart';
import 'package:global/bloc/chat/chat_state.dart';
import 'package:global/models/chat_message_model.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:global/widgets/network_error_widget.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final int supplierId;
  final String name;
  final String image;

  const ChatScreen({
    super.key,
    required this.supplierId,
    required this.name,
    required this.image,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _localMessages = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchChatMessagesRequested(widget.supplierId));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return "";
    try {
      final dateTime = DateTime.parse(timeStr).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return "";
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(SendMessageRequested(widget.supplierId, text));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.image)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is MessagesLoaded) {
                  setState(() {
                    _localMessages = List.from(state.messages);
                  });
                  _scrollToBottom();
                } else if (state is MessageSentSuccess) {
                  setState(() {
                    _localMessages.add(state.message);
                  });
                  _scrollToBottom();
                } else if (state is MessageSentFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                if (state is MessagesLoading && _localMessages.isEmpty) {
                  return const Center(child: CustomLoadingIndicator());
                } else if (state is MessagesFailure && _localMessages.isEmpty) {
                  return NetworkErrorWidget(
                    message: state.error,
                    onRetry: () {
                      context.read<ChatBloc>().add(
                        FetchChatMessagesRequested(widget.supplierId),
                      );
                    },
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _localMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _localMessages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildMessage(
                        text: msg.message,
                        isMe: msg.isMe,
                        time: _formatTime(msg.createdAt),
                        isNegotiation: msg.isNegotiation == 1,
                        senderName: msg.isMe ? null : widget.name,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required String text,
    required bool isMe,
    required String time,
    required bool isNegotiation,
    String? senderName,
  }) {
    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (!isMe && senderName != null) ...[
          Text(
            senderName,
            style: TextStyle(
              color: AppColors.yellowColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isMe ? AppColors.yellowColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.grey[800],
                  fontSize: 14,
                ),
              ),
              if (isNegotiation && !isMe) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement reject
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Reject",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement accept
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowColor,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Type here",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
