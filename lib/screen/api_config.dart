// ── ที่เก็บ API key ของแอปแบบรวมศูนย์ ──────────────────────
// แก้ key ที่นี่ "ที่เดียว" พอ — chatbot_page.dart และ dua_page.dart
// เรียกใช้ค่าจากไฟล์นี้ทั้งคู่ ไม่ต้อง hardcode ซ้ำในหลายที่อีกต่อไป
// (ก่อนหน้านี้เคย hardcode ซ้ำ 3 จุดใน 2 ไฟล์ ทำให้ตอนหมุน key ใหม่
// เสี่ยงลืมแก้บางจุด)
//
// วิธีหมุน key ใหม่: แก้ค่า defaultGeminiApiKey ด้านล่างบรรทัดเดียว
// แล้ว build แอปใหม่ ก็ใช้ key ใหม่ทั้งแอปทันที
class ApiConfig {
  static const String defaultGeminiApiKey = 'AQ.Ab8RN6KfH3zb7nLk5nSZtYT6VA_p5B8t5GISvCYLD6cW7BwDgw';
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
}