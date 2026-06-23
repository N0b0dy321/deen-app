import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NearbyMosquesPage extends StatefulWidget {
  const NearbyMosquesPage({super.key});

  @override
  State<NearbyMosquesPage> createState() => _NearbyMosquesPageState();
}

class _NearbyMosquesPageState extends State<NearbyMosquesPage> {
  static const String _apiKey = 'AIzaSyCaUkqQ4svNBF-1lwNOLNlbre18Ab8wh1U';

  bool _isLoading = true;
  String _errorMessage = '';
  Position? _currentPosition;
  List<Map<String, dynamic>> _mosques = [];
  GoogleMapController? _mapController; // ignore: unused_field
  Set<Marker> _markers = {};
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ── เปิด Google Maps นำทาง ──
  Future<void> _openNavigation(double lat, double lng, String name) async {
    final googleMapsUrl = Uri.parse(
      'google.navigation:q=$lat,$lng&mode=d',
    );
    final googleMapsWebUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permission denied';
            _isLoading = false;
          });
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() => _currentPosition = position);
      await _fetchNearbyMosques(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not get location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyMosques(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://places.googleapis.com/v1/places:searchNearby',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask':
              'places.displayName,places.formattedAddress,places.location,places.rating,places.currentOpeningHours,places.id',
        },
        body: json.encode({
          'includedTypes': ['mosque'],
          'maxResultCount': 20,
          'locationRestriction': {
            'circle': {
              'center': {
                'latitude': lat,
                'longitude': lng,
              },
              'radius': 5000.0,
            },
          },
        }),
      );

      final data = json.decode(response.body);

      if (data['places'] != null) {
        final results = data['places'] as List;
        final mosques = results.map((place) {
          final loc = place['location'];
          return {
            'name': place['displayName']?['text'] ?? 'Unknown',
            'address': place['formattedAddress'] ?? '',
            'lat': loc['latitude'],
            'lng': loc['longitude'],
            'rating': place['rating']?.toString() ?? '-',
            'open': place['currentOpeningHours']?['openNow'],
            'place_id': place['id'] ?? '',
          };
        }).toList();

        for (var mosque in mosques) {
          final distance = Geolocator.distanceBetween(
            lat, lng,
            mosque['lat'], mosque['lng'],
          );
          mosque['distance'] = distance < 1000
              ? '${distance.toStringAsFixed(0)} m'
              : '${(distance / 1000).toStringAsFixed(1)} km';
          mosque['distance_m'] = distance;
        }

        mosques.sort((a, b) =>
            (a['distance_m'] as double).compareTo(b['distance_m'] as double));

        final markers = mosques.map((mosque) {
          return Marker(
            markerId: MarkerId(mosque['place_id']),
            position: LatLng(mosque['lat'], mosque['lng']),
            infoWindow: InfoWindow(
              title: mosque['name'],
              snippet: mosque['distance'],
            ),
            onTap: () => _openNavigation(
              mosque['lat'], mosque['lng'], mosque['name'],
            ),
          );
        }).toSet();

        markers.add(Marker(
          markerId: const MarkerId('my_location'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ));

        setState(() {
          _mosques = mosques;
          _markers = markers;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${data['error']?['message'] ?? 'Unknown error'}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Please connect to the internet and try again';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          _buildHeader(context),
          if (!_isLoading && _errorMessage.isEmpty) _buildToggle(),
          Expanded(
            child: _isLoading
                ? _buildLoading()
                : _errorMessage.isNotEmpty
                    ? _buildError()
                    : _showMap
                        ? _buildMap()
                        : _buildList(),
          ),
        ],
      ),
      floatingActionButton: !_isLoading && _errorMessage.isEmpty
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1B5E20),
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.refresh, color: Colors.white),
            )
          : null,
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
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
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Icon(Icons.mosque, color: Color(0xFFFFD700), size: 40),
              const SizedBox(height: 8),
              const Text(
                'Nearby Mosques',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _currentPosition != null
                    ? 'Found ${_mosques.length} mosques nearby'
                    : 'Getting your location...',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showMap = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_showMap ? const Color(0xFF1B5E20) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list,
                          color: !_showMap ? Colors.white : Colors.grey, size: 18),
                      const SizedBox(width: 6),
                      Text('List',
                          style: TextStyle(
                              color: !_showMap ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showMap = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _showMap ? const Color(0xFF1B5E20) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map,
                          color: _showMap ? Colors.white : Colors.grey, size: 18),
                      const SizedBox(width: 6),
                      Text('Map',
                          style: TextStyle(
                              color: _showMap ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF1B5E20)),
          SizedBox(height: 16),
          Text('Finding nearby mosques...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _mosques.length,
      itemBuilder: (context, index) {
        final mosque = _mosques[index];
        final isOpen = mosque['open'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.mosque,
                        color: Color(0xFF1B5E20), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mosque['name'],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 13, color: Colors.grey),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(mosque['address'],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        if (mosque['rating'] != '-')
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 13, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(mosque['rating'],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(mosque['distance'],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20))),
                      const SizedBox(height: 4),
                      if (isOpen != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                                fontSize: 11,
                                color: isOpen ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              // ── ปุ่ม Navigate ──
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openNavigation(
                    mosque['lat'], mosque['lng'], mosque['name'],
                  ),
                  icon: const Icon(Icons.navigation, size: 16, color: Colors.white),
                  label: const Text('Navigate',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        zoom: 14,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) => _mapController = controller,
    );
  }
}