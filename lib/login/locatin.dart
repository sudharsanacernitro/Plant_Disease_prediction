import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  late GoogleMapController _mapController;

  // Initial location of the map (e.g., center of your country)
  static const LatLng _initialLocation = LatLng(28.7041, 77.1025); // Example: Delhi, India

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
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
                _selectedLocation = location;
              });
            },
            markers: _selectedLocation == null
                ? Set()
                : {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: _selectedLocation!,
                    ),
                  },
          ),
          if (_selectedLocation != null)
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
                        'Selected Location:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Latitude: ${_selectedLocation!.latitude}, Longitude: ${_selectedLocation!.longitude}'),
                      
                      ElevatedButton(
                    onPressed: () {
                      if(_selectedLocation!=null)
                      {
                         Navigator.pop(context, _selectedLocation);

                      }
                    },
                    child: Text('Confirm Location'),
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
