import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': message});
      isLoading = true;
    });

    controller.clear();

    final reply = await ChatService.sendMessage(message);

    setState(() {
      messages.add({'role': 'bot', 'text': reply});
      isLoading = false;
    });

    final box = Hive.box('chats');
    box.add({'user': message, 'bot': reply});
  }

  void loadPreviousMessages() {
    final box = Hive.box('chats');
    setState(() {
      messages.clear();
      for (var entry in box.values) {
        if (entry is Map<String, String>) {
          messages.add({'role': 'user', 'text': entry['user'] ?? ''});
          messages.add({'role': 'bot', 'text': entry['bot'] ?? ''});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreviousMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/ocr'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/chatbot.jpg', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg['role'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg['role'] == 'user'
                              ? Colors.blue.withOpacity(0.8)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Container(
                color: const Color.fromARGB(
                  255,
                  240,
                  236,
                  236,
                ).withOpacity(0.9),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => sendMessage(controller.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
