import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  // ── Default key ของแอป (ใช้เป็นค่าเริ่มต้นถ้า user ไม่ได้ตั้งของตัวเอง) ──
  // TODO: หมุน key นี้ทันทีที่ Google AI Studio เพราะเคยหลุดออกมาแล้ว
  static const String _defaultApiKey = 'AQ.Ab8RN6JiAfYN7ZtqxvALEExa_HfwiwRNURKZvzdIKNYN9Qfs8A';
  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // key ที่ user ตั้งเอง (ถ้ามี) ดึงมาจาก Settings > แชทบอต
  static const String userApiKeyPrefKey = 'user_gemini_api_key';

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final _lang = LanguageService();
  final _theme = ThemeService();

  static const String _systemPrompt = '''
You are an Islamic assistant for the Deen app. 
Your role is to answer questions about Islam including:
- Prayer (Salah), Fasting (Sawm), Zakat, Hajj
- Quran and Hadith
- Islamic history and scholars
- Halal/Haram guidelines
- Daily Islamic practices and Dua
Always respond respectfully and base answers on Quran and authentic Hadith.
Respond in the same language the user uses (All Language).
''';

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  /// เลือก API key ที่จะใช้จริง: ถ้า user ตั้งของตัวเองไว้ใน Settings > แชทบอต
  /// ให้ใช้ของ user ก่อนเสมอ ไม่งั้น fallback เป็น key เริ่มต้นของแอป
  Future<String> _resolveApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(userApiKeyPrefKey);
    if (userKey != null && userKey.trim().isNotEmpty) {
      return userKey.trim();
    }
    return _defaultApiKey;
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() { _messages.add({'role': 'user', 'content': text}); _isLoading = true; });
    _controller.clear();
    _scrollToBottom();
    try {
      final contents = [
        {'role': 'user', 'parts': [{'text': _systemPrompt}]},
        {'role': 'model', 'parts': [{'text': 'I understand. I am your Islamic assistant. How can I help you?'}]},
        ..._messages.map((msg) => {'role': msg['role'] == 'user' ? 'user' : 'model', 'parts': [{'text': msg['content']}]}),
      ];
      await Future.delayed(const Duration(seconds: 1));
      final apiKey = await _resolveApiKey();
      final response = await http.post(Uri.parse('$_apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'}, body: json.encode({'contents': contents}));
      final data = json.decode(response.body);
      if (data['candidates'] != null) {
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() { _messages.add({'role': 'assistant', 'content': reply}); _isLoading = false; });
      } else {
        // ถ้าใช้ key ของตัวเองแล้ว error (เช่น key ผิด/หมดโควต้า) แจ้งให้ตรงจุดกว่าเดิม
        final prefs = await SharedPreferences.getInstance();
        final usingOwnKey = (prefs.getString(userApiKeyPrefKey) ?? '').trim().isNotEmpty;
        final errorMsg = usingOwnKey
            ? (_lang.isThai
                ? 'ขอโทษครับ ใช้ API key ของคุณไม่สำเร็จ กรุณาเช็คที่ Settings > แชทบอต'
                : 'Sorry, your API key did not work. Please check Settings > Chatbot.')
            : (_lang.isThai ? 'ขอโทษครับ ไม่สามารถประมวลผลคำขอได้' : 'Sorry, I could not process your request.');
        setState(() { _messages.add({'role': 'assistant', 'content': errorMsg}); _isLoading = false; });
      }
    } catch (e) {
      setState(() { _messages.add({'role': 'assistant', 'content': 'Connection error. Please try again.'}); _isLoading = false; });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: _messages.isEmpty ? _buildWelcome() : _buildMessages()),
        _buildInput(),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp)),
              const Spacer(),
              GestureDetector(onTap: () => setState(() => _messages.clear()),
                  child: Icon(Icons.refresh, color: Colors.white70, size: 22.sp)),
            ]),
            SizedBox(height: 8.h),
            Container(width: 56.w, height: 56.h,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(Icons.smart_toy, color: Color(0xFFFFD700), size: 32.sp)),
            SizedBox(height: 8.h),
            Text(_lang.islamicAssistant,
                style: TextStyle(color: Color(0xFFFFD700), fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text(_lang.askAnything, style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }

  List<String> _getSuggestions() {
    switch (_lang.lang) {
      case 'th': return ['5 หลักของอิสลามคืออะไร?', 'วิธีทำวุฎูอ์?', 'ความสำคัญของละหมาดฟัจร์?', 'สอนซูเราะห์อัลฟาติฮะห์'];
      case 'ms': return ['Apakah 5 rukun Islam?', 'Bagaimana cara berwudhu?', 'Kepentingan solat Subuh?', 'Ajar saya Surah Al-Fatihah'];
      case 'id': return ['Apa 5 rukun Islam?', 'Bagaimana cara berwudhu?', 'Pentingnya sholat Subuh?', 'Ajarkan Surah Al-Fatihah'];
      case 'ar': return ['ما هي أركان الإسلام الخمسة؟', 'كيف أتوضأ؟', 'ما أهمية صلاة الفجر؟', 'علمني سورة الفاتحة'];
      case 'ur': return ['اسلام کے 5 ارکان کیا ہیں؟', 'وضو کیسے کریں؟', 'فجر کی نماز کی اہمیت؟', 'سورہ الفاتحہ سکھائیں'];
      case 'bn': return ['ইসলামের ৫টি স্তম্ভ কী?', 'কীভাবে ওজু করতে হয়?', 'ফজরের নামাজের গুরুত্ব?', 'সূরা আল-ফাতিহা শেখান'];
      default: return ['What are the 5 pillars of Islam?', 'How do I perform Wudu?', 'What is the importance of Fajr prayer?', 'Teach me Surah Al-Fatiha'];
    }
  }

  Widget _buildWelcome() {
    final suggestions = _getSuggestions();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(children: [
        SizedBox(height: 16.h),
        Text(_lang.assalamu, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: _theme.textColor)),
        SizedBox(height: 8.h),
        Text(_lang.askAnything, style: TextStyle(color: _theme.subTextColor)),
        SizedBox(height: 24.h),
        Align(alignment: Alignment.centerLeft,
          child: Text(_lang.suggestedQuestions,
              style: TextStyle(fontWeight: FontWeight.bold, color: _theme.subTextColor))),
        SizedBox(height: 12.h),
        ...suggestions.map((s) => GestureDetector(
          onTap: () => _sendMessage(s),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
              boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              Icon(Icons.chat_bubble_outline, color: _theme.iconColor, size: 18.sp),
              SizedBox(width: 12.w),
              Expanded(child: Text(s, style: TextStyle(fontSize: 14.sp, color: _theme.textColor))),
              Icon(Icons.chevron_right, color: _theme.subTextColor, size: 18.sp),
            ]),
          ),
        )),
      ]),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(width: 32.w, height: 32.h,
              decoration: BoxDecoration(color: _theme.iconColor, shape: BoxShape.circle),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 18.sp)),
            SizedBox(width: 8.w),
          ],
          Flexible(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isUser ? _theme.iconColor : _theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(isUser ? 16 : 4), bottomRight: Radius.circular(isUser ? 4 : 16)),
              border: !isUser && _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
              boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Text(text, style: TextStyle(fontSize: 14.sp,
                color: isUser ? Colors.white : _theme.textColor, height: 1.5.h)),
          )),
          if (isUser) SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(children: [
      Container(width: 32.w, height: 32.h,
        decoration: BoxDecoration(color: _theme.iconColor, shape: BoxShape.circle),
        child: Icon(Icons.smart_toy, color: Colors.white, size: 18.sp)),
      SizedBox(width: 8.w),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(color: _theme.cardColor, borderRadius: BorderRadius.circular(16.r)),
        child: Row(children: [_dot(0), SizedBox(width: 4.w), _dot(150), SizedBox(width: 4.w), _dot(300)]),
      ),
    ]);
  }

  Widget _dot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, value, child) => Container(width: 8.w, height: 8.h,
        decoration: BoxDecoration(color: Color.lerp(_theme.isDark ? const Color(0xFF2C3E50) : Colors.grey.shade300, _theme.iconColor, value),
            shape: BoxShape.circle)),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          border: _theme.isDark ? Border(top: BorderSide(color: ThemeService.darkBorder)) : null,
          boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(children: [
          Expanded(child: TextField(
            controller: _controller,
            style: TextStyle(color: _theme.textColor),
            decoration: InputDecoration(
              hintText: _lang.askPlaceholder,
              hintStyle: TextStyle(color: _theme.subTextColor),
              filled: true,
              fillColor: _theme.bgColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r),
                  borderSide: _theme.isDark ? BorderSide(color: ThemeService.darkBorder) : BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            onSubmitted: _sendMessage,
            textInputAction: TextInputAction.send,
          )),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(width: 48.w, height: 48.h,
              decoration: BoxDecoration(color: _theme.iconColor, shape: BoxShape.circle),
              child: Icon(Icons.send, color: Colors.white, size: 20.sp)),
          ),
        ]),
      ),
    );
  }
}