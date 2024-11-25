import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './current_loc.dart';


class GoogleMaps extends StatefulWidget {
    final List<LatLng> locations; // Accept a list of locations
    final List<String> disease_name;
  const GoogleMaps({super.key,required this.locations,required this.disease_name});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  LatLng? mylocation;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  List<LatLng?> locations = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      Map<String, double> coordinates = await getCurrentLocation();
     
      setState(() {
        mylocation = LatLng(coordinates['latitude']!, coordinates['longitude']!);
        locations.add(mylocation);

        setState(() {
                for (int i = 0; i < widget.locations.length; i++) {
                LatLng location = widget.locations[i]; // Get the location
                String disease = widget.disease_name[i]; // Get the disease name

                _markers.add(
                  Marker(
                    markerId: MarkerId(location.toString()),
                    position: location,
                    infoWindow: InfoWindow(
                      title: 'Affected Area',
                      snippet: disease, // Show disease name here
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Change color here
                  ),
                );

                print(i);
              }

            });
          }); 
    }catch (e) {
      print('Error: $e');
    }

    setState(() {
      for (LatLng? location in locations) {
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location!,
            infoWindow: const InfoWindow(
              title: 'Your Location',
            ),
          ),
        );
      }

      if (mylocation != null) {
        _circles.add(
          Circle(
            circleId: const CircleId('mylocation_circle'),
            center: mylocation!,
            radius: 1000, // Radius in meters
            strokeWidth: 3, // Border width of the circle
            strokeColor: Colors.blue, // Border color of the circle
            fillColor: Colors.blue.withOpacity(0.2), // Fill color of the circle
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Disease Affected Areas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: mylocation == null
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while location is being fetched
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mylocation!,
                zoom: 15,
              ),
              markers: _markers,
              circles: _circles,
            ),
    );
  }
}
