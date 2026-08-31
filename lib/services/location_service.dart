import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// จัดการตำแหน่งที่ user เลือกเอง (ค้นหาชื่อเมือง) สำหรับคำนวณเวลาละหมาด
/// แยกจาก GPS อัตโนมัติที่ PrayerService เคยใช้อยู่เดิม
class LocationService {
  // ── Google Places API key ──────────────────────────────────
  // ต้องเป็น key เดียวกับ MAPS_API_KEY ที่ใช้ใน AndroidManifest.xml
  static const String _googlePlacesApiKey = 'AIzaSyCaUkqQ4svNBF-1lwNOLNlbre18Ab8wh1U';

  static const _latKey = 'manual_location_lat';
  static const _lngKey = 'manual_location_lng';
  static const _nameKey = 'manual_location_name';

  /// คืนตำแหน่งที่ user เคยเลือกไว้ (ถ้ามี) — {lat, lng, name}
  /// คืน null ถ้ายังไม่เคยเลือกเอง (ให้ PrayerService ใช้ GPS ตามปกติ)
  static Future<Map<String, dynamic>?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    final name = prefs.getString(_nameKey);
    if (lat == null || lng == null || name == null) return null;
    return {'lat': lat, 'lng': lng, 'name': name};
  }

  /// บันทึกตำแหน่งที่ user เลือกเอง
  static Future<void> setSavedLocation({
    required double lat,
    required double lng,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
    await prefs.setString(_nameKey, name);
  }

  /// ล้างตำแหน่งที่เลือกเอง กลับไปใช้ GPS อัตโนมัติแทน
  static Future<void> clearSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latKey);
    await prefs.remove(_lngKey);
    await prefs.remove(_nameKey);
  }

  /// ค้นหาเมืองด้วยชื่อ (เช่น "สงขลา", "Songkhla", "London")
  /// ใช้ native geocoder ของเครื่อง (Android/iOS) ไม่ต้องมี API key แยก
  /// คืนรายการผลลัพธ์ {lat, lng, name} อาจได้หลายรายการถ้าชื่อซ้ำกันหลายที่
  static Future<List<Map<String, dynamic>>> searchCity(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final locations = await locationFromAddress(query);
      final results = <Map<String, dynamic>>[];

      // จำกัดแค่ 5 ผลลัพธ์แรก กันรายการยาวเกินไป
      for (final loc in locations.take(5)) {
        String displayName = query;
        try {
          final placemarks =
              await placemarkFromCoordinates(loc.latitude, loc.longitude);
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final parts = [p.locality, p.administrativeArea, p.country]
                .where((s) => s != null && s.isNotEmpty)
                .toList();
            if (parts.isNotEmpty) displayName = parts.join(', ');
          }
        } catch (_) {
          // reverse geocode ไม่สำเร็จ ใช้ query เดิมเป็นชื่อแสดงผลแทน
        }

        results.add({
          'lat': loc.latitude,
          'lng': loc.longitude,
          'name': displayName,
        });
      }

      return results;
    } catch (e) {
      throw Exception('ค้นหาเมืองไม่สำเร็จ: $e');
    }
  }

  // ── Google Places Autocomplete (New) — suggest แบบ real-time เหมือน Muslim Pro ──
  // ใช้ Places API (New) เพราะ Cloud Console ของโปรเจกต์นี้เปิด API ตัวนี้ไว้

  /// เรียก Places Autocomplete (New) คืนรายการ suggestion {description, placeId}
  /// จำกัดเฉพาะระดับเมือง (includedPrimaryTypes: locality) เพราะแอปนี้ใช้เลือกเมืองสำหรับเวลาละหมาด
  static Future<List<Map<String, String>>> autocompleteCity(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse('https://places.googleapis.com/v1/places:autocomplete');

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _googlePlacesApiKey,
          },
          body: json.encode({
            'input': query,
            // จำกัดกว้างพอที่จะครอบคลุมทั้งชื่อจังหวัด/อำเภอ/เมือง
            // (ตัดตัวกรองนี้ออกถ้ายังพบว่าบางชื่อค้นไม่เจออีก)
            'includedPrimaryTypes': [
              'locality',
              'administrative_area_level_1',
              'administrative_area_level_2',
              'administrative_area_level_3',
            ],
          }),
        )
        .timeout(const Duration(seconds: 8));

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      final message = data['error']?['message'] ?? response.body;
      throw Exception('Places API (New) ปฏิเสธคำขอ: $message');
    }

    final suggestions = (data['suggestions'] as List<dynamic>? ?? []);
    return suggestions
        .where((s) => s['placePrediction'] != null)
        .map<Map<String, String>>((s) {
      final pred = s['placePrediction'];
      return {
        'description': pred['text']['text'] as String,
        'placeId': pred['placeId'] as String,
      };
    }).toList();
  }

  /// แปลง placeId จาก autocomplete ให้เป็นพิกัดจริง (เรียกตอนผู้ใช้แตะเลือก suggestion)
  static Future<Map<String, dynamic>> getPlaceLatLng(String placeId, String fallbackName) async {
    final url = Uri.parse('https://places.googleapis.com/v1/places/$placeId');

    final response = await http.get(
      url,
      headers: {
        'X-Goog-Api-Key': _googlePlacesApiKey,
        'X-Goog-FieldMask': 'location,displayName,formattedAddress',
      },
    ).timeout(const Duration(seconds: 8));

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      final message = data['error']?['message'] ?? response.body;
      throw Exception('ดึงรายละเอียดสถานที่ไม่สำเร็จ: $message');
    }

    final location = data['location'];

    return {
      'lat': (location['latitude'] as num).toDouble(),
      'lng': (location['longitude'] as num).toDouble(),
      'name': fallbackName,
    };
  }

  /// ตรวจจับตำแหน่งปัจจุบันจาก GPS แล้วแปลงเป็นชื่อเมือง (ใช้ปุ่ม "ตำแหน่งปัจจุบัน")
  static Future<Map<String, dynamic>> detectCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('การเข้าถึงตำแหน่งถูกปิดถาวร กรุณาเปิดใน Settings ของเครื่อง');
    }

    final position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String displayName = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
    try {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.locality, p.administrativeArea, p.country]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        if (parts.isNotEmpty) displayName = parts.join(', ');
      }
    } catch (_) {}

    return {
      'lat': position.latitude,
      'lng': position.longitude,
      'name': displayName,
    };
  }
}