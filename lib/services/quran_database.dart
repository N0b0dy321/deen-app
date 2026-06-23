import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuranDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE surahs (
            id INTEGER PRIMARY KEY,
            name_simple TEXT,
            name_arabic TEXT,
            translated_name TEXT,
            verses_count INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE verses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah_id INTEGER,
            verse_number INTEGER,
            text_uthmani TEXT,
            translation TEXT,
            lang TEXT DEFAULT 'en'
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              "ALTER TABLE verses ADD COLUMN lang TEXT DEFAULT 'en'");
        }
      },
    );
  }

  // ── Surah ──────────────────────────────

  static Future<void> saveSurahs(List<dynamic> surahs) async {
    final db = await database;
    final batch = db.batch();
    for (final s in surahs) {
      batch.insert(
        'surahs',
        {
          'id': s['id'],
          'name_simple': s['name_simple'],
          'name_arabic': s['name_arabic'],
          'translated_name': s['translated_name']?['name'] ?? '',
          'verses_count': s['verses_count'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, dynamic>>> getSurahs() async {
    final db = await database;
    return await db.query('surahs', orderBy: 'id ASC');
  }

  static Future<bool> hasSurahs() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM surahs');
    return (result.first['count'] as int) > 0;
  }

  // ── Verses ─────────────────────────────

  static Future<void> saveVerses(int surahId, List<dynamic> verses) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('verses',
        where: 'surah_id = ? AND lang = ?', whereArgs: [surahId, 'en']);
    for (final v in verses) {
      final translation = v['translations'] != null &&
              (v['translations'] as List).isNotEmpty
          ? v['translations'][0]['text'] ?? ''
          : '';
      batch.insert('verses', {
        'surah_id': surahId,
        'verse_number': v['verse_number'],
        'text_uthmani': v['text_uthmani'] ?? '',
        'translation': translation,
        'lang': 'en',
      });
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, dynamic>>> getVerses(int surahId) async {
    final db = await database;
    return await db.query(
      'verses',
      where: 'surah_id = ? AND lang = ?',
      whereArgs: [surahId, 'en'],
      orderBy: 'verse_number ASC',
    );
  }

  static Future<bool> hasVerses(int surahId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM verses WHERE surah_id = ? AND lang = ?',
      [surahId, 'en'],
    );
    return (result.first['count'] as int) > 0;
  }

  static Future<bool> hasAllVerses() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(DISTINCT surah_id) as count FROM verses WHERE lang = ?',
      ['en'],
    );
    return (result.first['count'] as int) >= 114;
  }

  // ── Verses by Language ─────────────────

  static Future<void> saveVersesByLang(
      int surahId, String lang, List<dynamic> verses) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('verses',
        where: 'surah_id = ? AND lang = ?', whereArgs: [surahId, lang]);
    for (final v in verses) {
      final translation = v['translations'] != null &&
              (v['translations'] as List).isNotEmpty
          ? v['translations'][0]['text'] ?? ''
          : '';
      batch.insert('verses', {
        'surah_id': surahId,
        'verse_number': v['verse_number'],
        'text_uthmani': v['text_uthmani'] ?? '',
        'translation': translation,
        'lang': lang,
      });
    }
    await batch.commit(noResult: true);
  }

  static Future<void> saveProcessedVerses(
      int surahId, String lang, List<Map<String, dynamic>> verses) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('verses',
        where: 'surah_id = ? AND lang = ?', whereArgs: [surahId, lang]);
    for (final v in verses) {
      batch.insert('verses', {
        'surah_id': surahId,
        'verse_number': v['verse_number'],
        'text_uthmani': v['text_uthmani'] ?? '',
        'translation': v['translation'] ?? '',
        'lang': lang,
      });
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, dynamic>>> getVersesByLang(
      int surahId, String lang) async {
    final db = await database;
    return await db.query(
      'verses',
      where: 'surah_id = ? AND lang = ?',
      whereArgs: [surahId, lang],
      orderBy: 'verse_number ASC',
    );
  }

  static Future<bool> hasVersesByLang(int surahId, String lang) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM verses WHERE surah_id = ? AND lang = ?',
      [surahId, lang],
    );
    return (result.first['count'] as int) > 0;
  }

  static Future<void> deleteVersesByLang(int surahId, String lang) async {
    final db = await database;
    await db.delete('verses',
        where: 'surah_id = ? AND lang = ?', whereArgs: [surahId, lang]);
  }
}