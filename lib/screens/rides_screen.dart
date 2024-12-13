import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mrdrop/screens/home_screen.dart';
import 'package:mrdrop/screens/rideSelect.dart';

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

  Future<Map<String, dynamic>> _calculateRoute({
    required LatLng origin,
    required LatLng destination,
    LatLng? stopover,
  }) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    String waypoints = '';

    if (stopover != null) {
      waypoints = '&waypoints=${stopover.latitude},${stopover.longitude}';
    }

    final response = await http
        .get(Uri.parse('$baseUrl?origin=${origin.latitude},${origin.longitude}'
            '&destination=${destination.latitude},${destination.longitude}'
            '$waypoints'
            '&key=$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return {
        'distance': data['routes'][0]['legs'][0]['distance']['text'],
        'duration': data['routes'][0]['legs'][0]['duration']['text'],
      };
    }
    return {};
  }

  Future<void> calculateTrip() async {
    if (_currentPosition == null || _destinationPosition == null) {
      return;
    }

    if (isOneWaySelected) {
      Map<String, dynamic> details = await _calculateRoute(
        origin: _currentPosition!,
        destination: _destinationPosition!,
      );

      setState(() {
        _tripDetails = {
          'type': 'One Way Trip',
          'distance': details['distance'],
          'duration': details['duration'],
        };
      });
    } else {
      // Round trip calculation
      if (_stopPosition != null) {
        Map<String, dynamic> firstLeg = await _calculateRoute(
          origin: _currentPosition!,
          destination: _stopPosition!,
        );

        Map<String, dynamic> secondLeg = await _calculateRoute(
          origin: _stopPosition!,
          destination: _currentPosition!,
        );

        setState(() {
          _tripDetails = {
            'type': 'Round Trip',
            'total_distance':
                '${firstLeg['distance']} + ${secondLeg['distance']}',
            'total_duration':
                '${firstLeg['duration']} + ${secondLeg['duration']}',
          };
        });
      }
    }

    print(_tripDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                maxChildSize: 0.6,
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
                              _buildLocationInput(
                                'PICKUP',
                                _currentAddress ?? 'Fetching location...',
                                Icons.favorite_border,
                                Colors.blue,
                              ),
                              _buildDottedLine(),
                              _buildLocationInput(
                                'DROP',
                                'Where are you going?',
                                Icons.add,
                                Colors.orange,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Rideselect(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildLocationInput(
                                'PICKUP',
                                _currentAddress ?? 'Fetching location...',
                                Icons.favorite_border,
                                Colors.blue,
                              ),
                              _buildLocationInput(
                                'STOP',
                                'Where are you going?',
                                Icons.abc,
                                Colors.green,
                              ),
                              _buildLocationInput(
                                'RETURN',
                                'Same as pickup',
                                Icons.add,
                                Colors.red,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Rideselect(),
                                    ),
                                  );
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

  Widget _buildLocationInput(
    String label,
    String placeholder,
    IconData icon,
    Color labelColor, {
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (label == "STOP")
            const SizedBox.shrink()
          else
            IconButton(
              icon: Icon(
                icon,
                color: const Color.fromARGB(255, 73, 73, 73),
              ),
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 1,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final boxWidth = constraints.constrainWidth();
            const dashWidth = 5.0;
            const dashSpace = 3.0;
            final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

            return Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: List.generate(dashCount, (_) {
                return const SizedBox(
                  width: dashWidth,
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            height: 50,
            child: ElevatedButton(
              onPressed: calculateTrip,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.watch_later_outlined),
                  SizedBox(width: 12),
                  Text(
                    'Calculate',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.my_location,
              color: Colors.grey,
            ),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
    );
  }
}
