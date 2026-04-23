
import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum MessageRole { user, model }

class ChatMessage {
  final String id;
  final MessageRole role;
  final RxString text;
  final DateTime createdAt;
  final RxBool isStreaming;

  ChatMessage({
    required this.id,
    required this.role,
    String initialText = '',
    bool streaming = false,
  })  : text = RxString(initialText),
        isStreaming = RxBool(streaming),
        createdAt = DateTime.now();

  Map<String, dynamic> toGeminiPart() => {
        'role': role == MessageRole.user ? 'user' : 'model',
        'parts': [
          {'text': text.value}
        ],
      };
}