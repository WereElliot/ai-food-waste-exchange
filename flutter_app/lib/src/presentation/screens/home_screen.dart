import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:food_waste_exchange/src/data/repositories/listing_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-1.286389, 36.817223); // Nairobi
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final repository = ref.read(listingRepositoryProvider);
      final listings = await repository.getNearby(_center.latitude, _center.longitude);
      
      setState(() {
        _markers = listings.map((l) => Marker(
          markerId: MarkerId(l.id),
          position: LatLng(l.latitude, l.longitude),
          infoWindow: InfoWindow(
            title: l.title,
            snippet: '${l.quantity} - ${l.distance?.toStringAsFixed(1)}km away',
            onTap: () => context.go('/listing/${l.id}'),
          ),
        )).toSet();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching listings: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Surplus Food'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/impact'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {}, // Profile
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/create-listing'),
              icon: const Icon(Icons.add),
              label: const Text('Donate Surplus Food'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
