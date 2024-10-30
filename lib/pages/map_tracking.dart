import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTrackingPage extends StatefulWidget {
  const MapTrackingPage({super.key});

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends State<MapTrackingPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(0, 0);
  double searchRadius = 5.0; // default search radius in km

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _fetchNearbyFoodItems(_currentLocation);
  }

  void _fetchNearbyFoodItems(LatLng currentLocation) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('food_items').get();
    setState(() {
      _markers.clear(); // Clear previous markers
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        LatLng foodLocation = LatLng(data['latitude'], data['longitude']);

        double distance = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          foodLocation.latitude,
          foodLocation.longitude,
        ) / 1000; // convert to kilometers

        if (distance <= searchRadius) {
          _markers.add(Marker(
            markerId: MarkerId(doc.id),
            position: foodLocation,
            infoWindow: InfoWindow(
              title: data['name'],
              snippet: data['description'],
            ),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Tracking"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _currentLocation,
                      zoom: 14,
                    ),
                  ),
                );
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Search Radius (km):"),
                Slider(
                  value: searchRadius,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: "$searchRadius km",
                  onChanged: (value) {
                    setState(() {
                      searchRadius = value;
                    });
                    _fetchNearbyFoodItems(_currentLocation); // Refresh markers
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
