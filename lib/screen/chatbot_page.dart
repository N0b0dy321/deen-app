import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'api_config.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  // ── Default key ของแอป (ใช้เป็นค่าเริ่มต้นถ้า user ไม่ได้ตั้งของตัวเอง) ──
  // ดึงจาก api_config.dart ไฟล์เดียว (เดิมเคย hardcode ซ้ำอยู่ 3 จุดใน
  // 2 ไฟล์ รวมทั้งใน dua_page.dart ทำให้ตอนหมุน key ใหม่เสี่ยงลืมแก้บางจุด)
  static const String _defaultApiKey = ApiConfig.defaultGeminiApiKey;
  static const String _apiUrl = ApiConfig.geminiApiUrl;

  // key ที่ user ตั้งเอง (ถ้ามี) ดึงมาจาก Settings > แชทบอต
  static const String userApiKeyPrefKey = 'user_gemini_api_key';

  // ── จำกัดจำนวนข้อความ/วัน เฉพาะตอนใช้ default key ของแอป (ไม่จำกัดถ้า user
  // ตั้ง key ของตัวเอง เพราะนั่นเป็นโควต้าและค่าใช้จ่ายของเขาเอง) ──
  // เก็บเป็น "yyyy-MM-dd|count" ไว้ค่าเดียว รีเซ็ตอัตโนมัติเมื่อวันที่เปลี่ยน
  static const String _dailyUsagePrefKey = 'chatbot_daily_usage';
  static const int _dailyFreeLimit = 15;

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

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// อ่านจำนวนข้อความที่ใช้ default key ไปแล้ววันนี้ (รีเซ็ตอัตโนมัติข้ามวัน)
  Future<int> _getTodayUsage(SharedPreferences prefs) async {
    final stored = prefs.getString(_dailyUsagePrefKey);
    if (stored == null) return 0;
    final parts = stored.split('|');
    if (parts.length != 2 || parts[0] != _todayKey()) return 0;
    return int.tryParse(parts[1]) ?? 0;
  }

  Future<void> _incrementTodayUsage(SharedPreferences prefs, int current) async {
    await prefs.setString(_dailyUsagePrefKey, '${_todayKey()}|${current + 1}');
  }

  /// ยิง request ไปหา Gemini API พร้อม retry อัตโนมัติเมื่อเจอ 503
  /// (UNAVAILABLE — โมเดลมีคนใช้เยอะชั่วคราว) ลองใหม่สูงสุด 2 ครั้ง
  /// เว้นช่วงเพิ่มขึ้นเรื่อยๆ (1s, 2s) ก่อนจะยอมแพ้แล้วคืนผลลัพธ์สุดท้ายกลับไป
  Future<http.Response> _postWithRetry(String apiKey, List<Map<String, dynamic>> contents) async {
    const maxRetries = 2;
    http.Response response;
    for (int attempt = 0; ; attempt++) {
      response = await http.post(Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: json.encode({'contents': contents}));
      if (response.statusCode != 503 || attempt >= maxRetries) {
        return response;
      }
      debugPrint('[Chatbot] Gemini API 503 (busy) — retry ${attempt + 1}/$maxRetries');
      await Future.delayed(Duration(seconds: attempt + 1));
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(userApiKeyPrefKey);
    final usingOwnKey = userKey != null && userKey.trim().isNotEmpty;

    // ── เช็คโควต้ารายวันเฉพาะตอนใช้ default key ของแอป ──
    if (!usingOwnKey) {
      final used = await _getTodayUsage(prefs);
      if (used >= _dailyFreeLimit) {
        setState(() {
          _messages.add({'role': 'user', 'content': text});
          _messages.add({'role': 'assistant', 'content': _lang.isThai
              ? 'วันนี้ถามครบ $_dailyFreeLimit ข้อความแล้วครับ พรุ่งนี้ถามใหม่ได้ หรือใส่ Gemini API key ของคุณเองที่ Settings > แชทบอต เพื่อถามได้ไม่จำกัด'
              : 'You\'ve reached today\'s limit of $_dailyFreeLimit messages. Try again tomorrow, or add your own Gemini API key in Settings > Chatbot for unlimited messages.'});
        });
        _controller.clear();
        _scrollToBottom();
        return;
      }
    }

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
      // ── ส่ง API key ผ่าน header "x-goog-api-key" ตามวิธีที่ Google แนะนำ
      // ปัจจุบัน (เดิมส่งผ่าน query param ?key= ซึ่งยังใช้ได้แต่ไม่ใช่วิธีหลักแล้ว) ──
      final response = await _postWithRetry(apiKey, contents);
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['candidates'] != null) {
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() { _messages.add({'role': 'assistant', 'content': reply}); _isLoading = false; });
        // นับโควต้าเฉพาะตอนที่ยิง API สำเร็จจริง และใช้ default key เท่านั้น
        if (!usingOwnKey) {
          final used = await _getTodayUsage(prefs);
          await _incrementTodayUsage(prefs, used);
        }
      } else {
        // log สถานะ + เนื้อหา error จริงจาก Google ลง console เพื่อ debug
        // (ก่อนหน้านี้กลืน error ทิ้งหมด ทำให้ไม่รู้ว่าสาเหตุจริงคืออะไร
        // เช่น key ผิด/model ผิดชื่อ/หมดโควต้า)
        debugPrint('[Chatbot] Gemini API error — status: ${response.statusCode}, body: ${response.body}');
        // ถ้าใช้ key ของตัวเองแล้ว error (เช่น key ผิด/หมดโควต้า) แจ้งให้ตรงจุดกว่าเดิม
        final errorMsg = usingOwnKey
            ? (_lang.isThai
                ? 'ขอโทษครับ ใช้ API key ของคุณไม่สำเร็จ กรุณาเช็คที่ Settings > แชทบอต'
                : 'Sorry, your API key did not work. Please check Settings > Chatbot.')
            : (_lang.isThai ? 'ขอโทษครับ ไม่สามารถประมวลผลคำขอได้' : 'Sorry, I could not process your request.');
        setState(() { _messages.add({'role': 'assistant', 'content': errorMsg}); _isLoading = false; });
      }
    } catch (e) {
      debugPrint('[Chatbot] Connection error: $e');
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