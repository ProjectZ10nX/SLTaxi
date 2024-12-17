import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mrdrop/screens/home_screen.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  late GoogleMapController mapController;
  final String apiKey = 'AIzaSyC3s_-UH3lsrmhkJk4kGBPpPiHcw4s1EP8';
  LatLng? _currentPosition;
  String? _currentAddress;
  String? _destinationAddress;
  LatLng? _destinationPosition;
  LatLng? _stopPosition;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  LatLng? _stopLocation;
  LatLng? _returnLocation;
  bool isOneWaySelected = true;

  Map<String, dynamic> _tripDetails = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //Fetch Place Suggestions
  Future<List<Map<String, dynamic>>> _fetchPlaceSuggestions(
      String input, String apiKey) async {
    if (input.isEmpty) {
      return []; // Return an empty list if the input is empty
    }

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check for errors in the API response
        if (data['status'] != "OK") {
          print("Google Places API Error: ${data['status']}");
          return []; // Return an empty list if there's an error
        }

        List predictions = data['predictions'];
        return predictions
            .map((e) =>
                {'description': e['description'], 'place_id': e['place_id']})
            .toList();
      } else {
        throw Exception(
            "Failed to fetch suggestions. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching place suggestions: $e");
      return [];
    }
  }

  //Get Latlang From Place ID
  Future<LatLng> _getLatLngFromPlaceId(String placeId, String apiKey) async {
    final String url = "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception("Failed to fetch location details");
      }
    } catch (e) {
      print(e);
      return LatLng(0, 0); // Return default value on failure
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _getAddressFromLatLng(_currentPosition!);

      // Update camera position to current location
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? const LatLng(6.9271, 79.8612),
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                if (_currentPosition != null)
                  Marker(
                    markerId: const MarkerId('origin'),
                    position: _currentPosition!,
                    infoWindow: InfoWindow(title: _currentAddress),
                  ),
                if (_destinationPosition != null)
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: _destinationPosition!,
                    infoWindow: InfoWindow(title: _destinationAddress),
                  ),
                if (_stopPosition != null)
                  Marker(
                    markerId: const MarkerId('stopover'),
                    position: _stopPosition!,
                  ),
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 400),
              child: _buildBottomButton(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Colors.black26)
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const SizedBox(height: 10),
                        _buildTripTypeSelector(),
                        const SizedBox(height: 10),
                        if (isOneWaySelected)
                          Column(
                            children: [
                              // Pickup Location
                              _buildLocationInput(
                                'PICKUP',
                                _currentAddress ?? 'Fetching location...',
                                Icons.favorite_border,
                                Colors.blue,
                                apiKey:
                                    'AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ',
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _pickupLocation = location;
                                  });
                                  print(
                                      "Pickup Location: ${location.latitude}, ${location.longitude}");
                                },
                              ),
                              _buildDottedLine(),
                              // Drop Location
                              _buildLocationInput(
                                'DROP',
                                'Where are you going?',
                                Icons.add,
                                Colors.orange,
                                apiKey:
                                    'AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ',
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _dropLocation = location;
                                  });
                                  print(
                                      "Drop Location: ${location.latitude}, ${location.longitude}");
                                },
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              // Pickup Location
                              _buildLocationInput(
                                'PICKUP',
                                _currentAddress ?? 'Fetching location...',
                                Icons.favorite_border,
                                Colors.blue,
                                apiKey:
                                    'AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ',
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _pickupLocation = location;
                                  });
                                  print(
                                      "Pickup Location: ${location.latitude}, ${location.longitude}");
                                },
                              ),
                              // Stop Location
                              _buildLocationInput(
                                'STOP',
                                'Where are you going?',
                                Icons.abc,
                                Colors.green,
                                apiKey:
                                    'AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ',
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _stopLocation = location;
                                  });
                                  print(
                                      "Stop Location: ${location.latitude}, ${location.longitude}");
                                },
                              ),
                              // Return Location
                              _buildLocationInput(
                                'RETURN',
                                'Same as pickup',
                                Icons.add,
                                Colors.red,
                                apiKey:
                                    'AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ',
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _returnLocation = location;
                                  });
                                  print(
                                      "Return Location: ${location.latitude}, ${location.longitude}");
                                },
                              ),
                            ],
                          ),
                        if (_tripDetails.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Trip Type: ${_tripDetails['type']}'),
                                if (isOneWaySelected) ...[
                                  Text('Distance: ${_tripDetails['distance']}'),
                                  Text('Duration: ${_tripDetails['duration']}'),
                                ] else ...[
                                  Text(
                                      'Total Distance: ${_tripDetails['total_distance']}'),
                                  Text(
                                      'Total Duration: ${_tripDetails['total_duration']}'),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSelectableCard('One Way', isOneWaySelected, () {
            setState(() {
              isOneWaySelected = true;
            });
          }),
          _buildSelectableCard('Return Trip*', !isOneWaySelected, () {
            setState(() {
              isOneWaySelected = false;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSelectableCard(
      String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Widget _buildLocationInput(
  //   String label,
  //   String placeholder,
  //   IconData icon,
  //   Color labelColor, {
  //   VoidCallback? onPressed,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 80,
  //           height: 30,
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade200,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           padding: const EdgeInsets.all(4),
  //           child: Center(
  //             child: Text(
  //               label,
  //               style: const TextStyle(
  //                 color: Colors.green,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 20),
  //         Expanded(
  //           child: TextField(
  //             decoration: InputDecoration(
  //               hintText: placeholder,
  //               border: InputBorder.none,
  //               isDense: true,
  //             ),
  //             style: const TextStyle(fontSize: 14),
  //           ),
  //         ),
  //         if (label == "STOP")
  //           const SizedBox.shrink()
  //         else
  //           IconButton(
  //             icon: Icon(
  //               icon,
  //               color: const Color.fromARGB(255, 73, 73, 73),
  //             ),
  //             onPressed: onPressed,
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLocationInput(
    String label,
    String placeholder,
    IconData icon,
    Color labelColor, {
    required String apiKey,
    required Function(LatLng) onLocationSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: labelColor,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: label,
                  hintText: placeholder,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await _fetchPlaceSuggestions(pattern, apiKey);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['description']),
                );
              },
              onSuggestionSelected: (suggestion) async {
                LatLng location =
                    await _getLatLngFromPlaceId(suggestion['place_id'], apiKey);
                onLocationSelected(location);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          print("Trip confirmed with details:");
          print("Pickup Location: $_pickupLocation");
          print("Drop Location: $_dropLocation");
          print("Stop Location: $_stopLocation");
        },
        child: const Text(
          'CONFIRM TRIP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
