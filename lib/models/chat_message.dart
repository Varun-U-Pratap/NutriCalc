enum MessageSender { user, bot }

class ChatMessage {
  final String text;
  final MessageSender sender;

  ChatMessage({
    required this.text,
    required this.sender,
  });
}
