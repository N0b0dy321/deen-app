import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/language_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  static const String _apiKey = 'AQ.Ab8RN6JiAfYN7ZtqxvALEExa_HfwiwRNURKZvzdIKNYN9Qfs8A';
  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final _lang = LanguageService();

  static const String _systemPrompt = '''
You are an Islamic assistant for the Deen app. 
Your role is to answer questions about Islam including:
- Prayer (Salah), Fasting (Sawm), Zakat, Hajj
- Quran and Hadith
- Islamic history and scholars
- Halal/Haram guidelines
- Daily Islamic practices and Dua

Always respond respectfully and base answers on Quran and authentic Hadith.
If asked about non-Islamic topics, kindly redirect to Islamic topics.
Respond in the same language the user uses (Thai or English).
''';

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _lang.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() { _messages.add({'role': 'user', 'content': text}); _isLoading = true; });
    _controller.clear();
    _scrollToBottom();

    try {
      final contents = [
        {'role': 'user', 'parts': [{'text': _systemPrompt}]},
        {'role': 'model', 'parts': [{'text': 'I understand. I am your Islamic assistant for the Deen app. How can I help you?'}]},
        ..._messages.map((msg) => {'role': msg['role'] == 'user' ? 'user' : 'model', 'parts': [{'text': msg['content']}]}),
      ];

      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'contents': contents}),
      );

      final data = json.decode(response.body);
      if (data['candidates'] != null) {
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() { _messages.add({'role': 'assistant', 'content': reply}); _isLoading = false; });
      } else {
        setState(() {
          _messages.add({'role': 'assistant', 'content': 'Sorry, I could not process your request. Please try again.'});
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Connection error. Please check your internet and try again.'});
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _messages.isEmpty ? _buildWelcome() : _buildMessages()),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _messages.clear()),
                    child: const Icon(Icons.refresh, color: Colors.white70, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy, color: Color(0xFFFFD700), size: 32),
              ),
              const SizedBox(height: 8),
              Text(_lang.islamicAssistant,
                  style: const TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_lang.askAnything, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    final suggestions = _lang.isThai
        ? ['5 หลักของอิสลามคืออะไร?', 'วิธีทำวุฎูอ์?', 'ความสำคัญของละหมาดฟัจร์?', 'สอนซูเราะห์อัลฟาติฮะห์']
        : ['What are the 5 pillars of Islam?', 'How do I perform Wudu?', 'What is the importance of Fajr prayer?', 'Teach me Surah Al-Fatiha'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(_lang.assalamu,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(_lang.askAnything, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(_lang.suggestedQuestions,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          ),
          const SizedBox(height: 12),
          ...suggestions.map((s) => GestureDetector(
                onTap: () => _sendMessage(s),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Color(0xFF1B5E20), size: 18),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s, style: const TextStyle(fontSize: 14, color: Colors.black87))),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) return _buildTypingIndicator();
        final msg = _messages[index];
        return _buildBubble(msg['content']!, msg['role'] == 'user');
      },
    );
  }

  Widget _buildBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: Color(0xFF1B5E20), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF1B5E20) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Text(text, style: TextStyle(fontSize: 14, color: isUser ? Colors.white : Colors.black87, height: 1.5)),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: const BoxDecoration(color: Color(0xFF1B5E20), shape: BoxShape.circle),
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [_dot(0), const SizedBox(width: 4), _dot(150), const SizedBox(width: 4), _dot(300)]),
        ),
      ],
    );
  }

  Widget _dot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, value, child) => Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: Color.lerp(Colors.grey.shade300, const Color(0xFF1B5E20), value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _lang.askPlaceholder,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(color: Color(0xFF1B5E20), shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}