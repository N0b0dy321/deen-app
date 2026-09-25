import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../services/language_service.dart';
import '../services/theme_service.dart';

// ── ไอคอนฮาลาล (silhouette ขาว export จาก Canva แบบโปร่งใส) แทน emoji 🍽️
// เดิม ทาสีทองทับด้วย ColorFiltered ให้เข้ากับสีหัวข้อ (Color(0xFFFFD700)) ──
const String kHalalIconAsset = 'image/decor/halal_icon.png';

class HalalRestaurantPage extends StatefulWidget {
  const HalalRestaurantPage({super.key});
  @override
  State<HalalRestaurantPage> createState() => _HalalRestaurantPageState();
}

class _HalalRestaurantPageState extends State<HalalRestaurantPage> {
  static const String _apiKey = 'AIzaSyCaUkqQ4svNBF-1lwNOLNlbre18Ab8wh1U';
  bool _isLoading = true;
  String _errorMessage = '';
  Position? _currentPosition;
  List<Map<String, dynamic>> _restaurants = [];
  Set<Marker> _markers = {};
  bool _showMap = false;
  final _lang = LanguageService();
  final _theme = ThemeService();

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _openNavigation(double lat, double lng, String name) async {
    final googleMapsUrl = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    final googleMapsWebUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _errorMessage = 'Location permission denied'; _isLoading = false; });
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _currentPosition = position);
      await _fetchNearbyRestaurants(position.latitude, position.longitude);
    } catch (e) {
      setState(() { _errorMessage = 'Could not get location: $e'; _isLoading = false; });
    }
  }

  Future<void> _fetchNearbyRestaurants(double lat, double lng) async {
    try {
      final response = await http.post(
        Uri.parse('https://places.googleapis.com/v1/places:searchText'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location,places.rating,places.currentOpeningHours,places.id,places.priceLevel',
        },
        body: json.encode({
          'textQuery': 'halal restaurant',
          'maxResultCount': 20,
          'locationBias': {
            'circle': {
              'center': {'latitude': lat, 'longitude': lng},
              'radius': 3000.0,
            }
          },
          'languageCode': 'th',
        }),
      );

      final data = json.decode(response.body);
      if (data['places'] != null) {
        final restaurants = (data['places'] as List).map((place) {
          final loc = place['location'];
          return {
            'name': place['displayName']?['text'] ?? 'Unknown',
            'address': place['formattedAddress'] ?? '',
            'lat': loc['latitude'],
            'lng': loc['longitude'],
            'rating': place['rating']?.toString() ?? '-',
            'open': place['currentOpeningHours']?['openNow'],
            'place_id': place['id'] ?? '',
            'price': place['priceLevel'] ?? '',
          };
        }).toList();

        for (var r in restaurants) {
          final distance = Geolocator.distanceBetween(lat, lng, r['lat'], r['lng']);
          r['distance'] = distance < 1000
              ? '${distance.toStringAsFixed(0)} m'
              : '${(distance / 1000).toStringAsFixed(1)} km';
          r['distance_m'] = distance;
        }
        restaurants.sort((a, b) => (a['distance_m'] as double).compareTo(b['distance_m'] as double));

        final markers = restaurants.map((r) => Marker(
          markerId: MarkerId(r['place_id']),
          position: LatLng(r['lat'], r['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: r['name'], snippet: r['distance']),
          onTap: () => _openNavigation(r['lat'], r['lng'], r['name']),
        )).toSet();

        markers.add(Marker(
          markerId: const MarkerId('my_location'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ));

        setState(() { _restaurants = restaurants; _markers = markers; _isLoading = false; });
      } else {
        setState(() { _errorMessage = 'Error: ${data['error']?['message'] ?? 'Unknown error'}'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Please connect to the internet and try again'; _isLoading = false; });
    }
  }

  String _getPriceLevel(String price) {
    switch (price) {
      case 'PRICE_LEVEL_INEXPENSIVE': return '฿';
      case 'PRICE_LEVEL_MODERATE': return '฿฿';
      case 'PRICE_LEVEL_EXPENSIVE': return '฿฿฿';
      case 'PRICE_LEVEL_VERY_EXPENSIVE': return '฿฿฿฿';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        if (!_isLoading && _errorMessage.isEmpty) _buildToggle(),
        Expanded(child: _isLoading
            ? _buildLoading()
            : _errorMessage.isNotEmpty
                ? _buildError()
                : _showMap ? _buildMap() : _buildList()),
      ]),
      floatingActionButton: !_isLoading && _errorMessage.isEmpty
          ? FloatingActionButton(
              backgroundColor: _theme.iconColor,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.refresh, color: Colors.white))
          : null,
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
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
            ]),
            const SizedBox(height: 12),
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Color(0xFFFFD700), BlendMode.srcIn),
              child: Image.asset(
                kHalalIconAsset,
                width: 44, height: 44,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.restaurant_menu, color: Color(0xFFFFD700), size: 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _lang.isThai ? 'ร้านอาหารฮาลาล' : 'Halal Restaurants',
              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              _currentPosition != null
                  ? _lang.isThai
                      ? 'พบ ${_restaurants.length} ร้านใกล้คุณ'
                      : 'Found ${_restaurants.length} restaurants nearby'
                  : _lang.isThai ? 'กำลังหาตำแหน่ง...' : 'Getting location...',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _showMap = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !_showMap ? _theme.iconColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.list, color: !_showMap ? Colors.white : _theme.subTextColor, size: 18),
                const SizedBox(width: 6),
                Text(_lang.isThai ? 'รายการ' : 'List',
                    style: TextStyle(color: !_showMap ? Colors.white : _theme.subTextColor, fontWeight: FontWeight.bold)),
              ]),
            ),
          )),
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _showMap = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _showMap ? _theme.iconColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.map, color: _showMap ? Colors.white : _theme.subTextColor, size: 18),
                const SizedBox(width: 6),
                Text(_lang.isThai ? 'แผนที่' : 'Map',
                    style: TextStyle(color: _showMap ? Colors.white : _theme.subTextColor, fontWeight: FontWeight.bold)),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(color: _theme.iconColor),
      const SizedBox(height: 16),
      Text(
        _lang.isThai ? 'กำลังหาร้านอาหารฮาลาล...' : 'Finding halal restaurants...',
        style: TextStyle(color: _theme.subTextColor)),
    ]));
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 48),
      const SizedBox(height: 16),
      Text(_errorMessage, style: TextStyle(color: _theme.subTextColor), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _getCurrentLocation,
        style: ElevatedButton.styleFrom(backgroundColor: _theme.iconColor),
        child: Text(_lang.isThai ? 'ลองอีกครั้ง' : 'Try Again',
            style: const TextStyle(color: Colors.white))),
    ]));
  }

  Widget _buildList() {
    return ListView.builder(
      // เว้นพื้นที่ด้านล่างให้พอสำหรับ FloatingActionButton (refresh) + safe area ของเครื่อง
      // ไม่งั้นปุ่ม FAB จะไปทับปุ่ม "Navigate" ของการ์ดสุดท้ายพอดี (บั๊กเดียวกับหน้า Nearby Mosques)
      padding: EdgeInsets.fromLTRB(
        16, 0, 16, 88 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: _restaurants.length,
      itemBuilder: (context, index) {
        final r = _restaurants[index];
        final isOpen = r['open'];
        final price = _getPriceLevel(r['price'].toString());

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.restaurant, color: Colors.orange, size: 28)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(r['name'],
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _theme.textColor))),
                  // Halal badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.3)),
                    ),
                    child: const Text('HALAL',
                        style: TextStyle(fontSize: 9, color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.location_on, size: 13, color: _theme.subTextColor),
                  const SizedBox(width: 2),
                  Expanded(child: Text(r['address'],
                      style: TextStyle(fontSize: 12, color: _theme.subTextColor),
                      overflow: TextOverflow.ellipsis)),
                ]),
                Row(children: [
                  if (r['rating'] != '-') ...[
                    const Icon(Icons.star, size: 13, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(r['rating'], style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
                    const SizedBox(width: 8),
                  ],
                  if (price.isNotEmpty)
                    Text(price, style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(r['distance'],
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _theme.iconColor)),
                const SizedBox(height: 4),
                if (isOpen != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      isOpen
                          ? (_lang.isThai ? 'เปิด' : 'Open')
                          : (_lang.isThai ? 'ปิด' : 'Closed'),
                      style: TextStyle(
                          fontSize: 11,
                          color: isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold))),
              ]),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openNavigation(r['lat'], r['lng'], r['name']),
                icon: const Icon(Icons.navigation, size: 16, color: Colors.white),
                label: Text(
                  _lang.isThai ? 'นำทาง' : 'Navigate',
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _theme.iconColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}