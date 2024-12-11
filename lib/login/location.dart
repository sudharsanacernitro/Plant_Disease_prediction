import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  // Initial location of the map (e.g., center of your country)
  static const LatLng _initialLocation = LatLng(28.7041, 77.1025); // Example: Delhi, India

  // Set to store multiple markers
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Locations'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                // Add a new marker for each selected location
                _markers.add(
                  Marker(
                    markerId: MarkerId(location.toString()),
                    position: location,
                  ),
                );
              });
            },
            markers: _markers,
          ),
          if (_markers.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Selected Locations:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: _markers.map((marker) {
                          return Text(
                              'Lat: ${marker.position.latitude}, Lng: ${marker.position.longitude}');
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_markers.isNotEmpty) {
                            // Return all selected locations
                            print(_markers);
                            Navigator.pop(
                                context,
                                _markers
                                    .map((marker) => marker.position)
                                    .toList());
                          }
                        },
                        child: Text('Confirm Locations'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
