import 'package:flutter/material.dart';
import '../widgets/topbar.dart';
import '../widgets/footer.dart';

class SuportePage extends StatefulWidget {
  const SuportePage({super.key});

  @override
  State<SuportePage> createState() => _SuportePageState();
}

class _SuportePageState extends State<SuportePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'user': text});
      _messages.add({'bot': 'Resposta gerada pelo bot (substituir pela API).'});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopBar(),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _messages.map((msg) {
                        final isUser = msg.containsKey('user');
                        return Container(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.green[100] : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg.values.first!),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              hintText: 'Digite sua mensagem...'),
                        ),
                      ),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
