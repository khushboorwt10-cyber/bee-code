import 'dart:async';
import 'package:beecode/screens/ai/model/ai_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isStreaming = false.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool _cancelled = false;
  Future<void> sendMessage(String userText) async {
    final trimmed = userText.trim();
    if (trimmed.isEmpty || isLoading.value) return;

    errorMessage.value = '';
    inputController.clear();

    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      initialText: trimmed,
    ));

    final modelMsg = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_model',
      role: MessageRole.model,
      streaming: true,
    );
    messages.add(modelMsg);

    isLoading.value = true;
    isStreaming.value = true;
    _cancelled = false;
    _scrollToBottom();

    try {
      await _generateResponse(trimmed, modelMsg);
    } catch (e) {
      errorMessage.value = e.toString();
      modelMsg.text.value = '⚠️ Error: $e';
    } finally {
      modelMsg.isStreaming.value = false;
      isLoading.value = false;
      isStreaming.value = false;
      _scrollToBottom();
    }
  }
  Future<void> _generateResponse(String userText, ChatMessage target) async {
    const reply = "Hello! I'm ready to help. Please connect me to an AI API.";
    for (final word in reply.split(' ')) {
      if (_cancelled) break;
      await Future.delayed(const Duration(milliseconds: 80));
      target.text.value += '$word ';
      _scrollToBottom();
    }
  }

  void cancelStream() {
    _cancelled = true;
    isLoading.value = false;
    isStreaming.value = false;
    if (messages.isNotEmpty &&
        messages.last.role == MessageRole.model &&
        messages.last.isStreaming.value) {
      messages.last.isStreaming.value = false;
    }
  }

  void clearChat() {
    cancelStream();
    messages.clear();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}