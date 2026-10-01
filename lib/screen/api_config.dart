// ── ที่เก็บ API key ของแอปแบบรวมศูนย์ ──────────────────────
// แก้ key ที่นี่ "ที่เดียว" พอ — chatbot_page.dart และ dua_page.dart
// เรียกใช้ค่าจากไฟล์นี้ทั้งคู่ ไม่ต้อง hardcode ซ้ำในหลายที่อีกต่อไป
// (ก่อนหน้านี้เคย hardcode ซ้ำ 3 จุดใน 2 ไฟล์ ทำให้ตอนหมุน key ใหม่
// เสี่ยงลืมแก้บางจุด)
//
// วิธีหมุน key ใหม่: แก้ค่า defaultGeminiApiKey ด้านล่างบรรทัดเดียว
// แล้ว build แอปใหม่ ก็ใช้ key ใหม่ทั้งแอปทันที
class ApiConfig {
  static const String defaultGeminiApiKey = 'AQ.Ab8RN6K0Z99iR1o4YzAS_pzDdZsKt8hW_t2y6R-0uIpNHiXt1A';
  // gemini-2.5-flash-lite ถูก Google ปิดไม่ให้ผู้ใช้ใหม่เรียกแล้ว (error 404
  // "no longer available to new users") — Google แนะนำให้ใช้
  // gemini-3.5-flash-lite แทนโดยตรงในข้อความ error เอง จึงเปลี่ยนตามนั้น
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent';
}