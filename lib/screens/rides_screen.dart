// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:mrdrop/screens/home_screen.dart';

// class RidesScreen extends StatefulWidget {
//   const RidesScreen({super.key});

//   @override
//   State<RidesScreen> createState() => _RidesScreenState();
// }

// class _RidesScreenState extends State<RidesScreen> {
//   late GoogleMapController mapController;
//   final String apiKey = 'AIzaSyC3s_-UH3lsrmhkJk4kGBPpPiHcw4s1EP8';
//   LatLng? _currentPosition;
//   String? _currentAddress;
//   String? _destinationAddress;
//   LatLng? _destinationPosition;
//   LatLng? _stopPosition;
//   LatLng? _pickupLocation;
//   LatLng? _dropLocation;
//   LatLng? _stopLocation;
//   LatLng? _returnLocation;
//   bool isOneWaySelected = true;
//   final TextEditingController _pickupController = TextEditingController();
//   final TextEditingController _dropController = TextEditingController();
//   final TextEditingController _stopController = TextEditingController();
//   final TextEditingController _returnController = TextEditingController();

//   Map<String, dynamic> _tripDetails = {};

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   //Fetch Place Suggestions
//   Future<List<Map<String, dynamic>>> _fetchPlaceSuggestions(
//       String input, String apiKey) async {
//     if (input.isEmpty) {
//       return []; // Return an empty list if the input is empty
//     }

//     final String url =
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json"
//         "?input=$input&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         // Check for errors in the API response
//         if (data['status'] != "OK") {
//           print("Google Places API Error: ${data['status']}");
//           return []; // Return an empty list if there's an error
//         }

//         List predictions = data['predictions'];
//         return predictions
//             .map((e) =>
//                 {'description': e['description'], 'place_id': e['place_id']})
//             .toList();
//       } else {
//         throw Exception(
//             "Failed to fetch suggestions. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching place suggestions: $e");
//       return [];
//     }
//   }

//   //Get Latlang From Place ID
//   Future<LatLng> _getLatLngFromPlaceId(String placeId, String apiKey) async {
//     final String url = "https://maps.googleapis.com/maps/api/place/details/json"
//         "?place_id=$placeId&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['status'] != 'OK') {
//           print("Google Place Details Error: ${data['status']}");
//           return LatLng(0, 0); // Return default for failure
//         }

//         final location = data['result']['geometry']['location'];
//         final lat = location['lat'];
//         final lng = location['lng'];
//         print("Fetched Location: Lat=$lat, Lng=$lng"); // Debug log

//         return LatLng(lat, lng);
//       } else {
//         print("HTTP Error: ${response.statusCode}");
//         return LatLng(0, 0);
//       }
//     } catch (e) {
//       print("Exception in _getLatLngFromPlaceId: $e");
//       return LatLng(0, 0);
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });

//       _getAddressFromLatLng(_currentPosition!);

//       // Update camera position to current location
//       if (mapController != null) {
//         mapController.animateCamera(
//           CameraUpdate.newLatLng(_currentPosition!),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//             "${place.street}, ${place.locality}, ${place.postalCode}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition ?? const LatLng(6.9271, 79.8612),
//                 zoom: 13.0,
//               ),
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               markers: {
//                 if (_currentPosition != null)
//                   Marker(
//                     markerId: const MarkerId('origin'),
//                     position: _currentPosition!,
//                     infoWindow: InfoWindow(title: _currentAddress),
//                   ),
//                 if (_destinationPosition != null)
//                   Marker(
//                     markerId: const MarkerId('destination'),
//                     position: _destinationPosition!,
//                     infoWindow: InfoWindow(title: _destinationAddress),
//                   ),
//                 if (_stopPosition != null)
//                   Marker(
//                     markerId: const MarkerId('stopover'),
//                     position: _stopPosition!,
//                   ),
//               },
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HomeScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _getCurrentLocation,
//                   icon: const Icon(
//                     Icons.location_on_outlined,
//                     color: Colors.black,
//                   ),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 400),
//               child: _buildBottomButton(),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: DraggableScrollableSheet(
//                 initialChildSize: 0.35,
//                 minChildSize: 0.2,
//                 maxChildSize: 0.9,
//                 builder: (context, scrollController) {
//                   return Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                       boxShadow: [
//                         BoxShadow(blurRadius: 10, color: Colors.black26)
//                       ],
//                     ),
//                     child: ListView(
//                       controller: scrollController,
//                       children: [
//                         const SizedBox(height: 10),
//                         _buildTripTypeSelector(),
//                         const SizedBox(height: 10),
//                         if (isOneWaySelected)
//                           Column(
//                             children: [
//                               // Pickup Location
//                               _buildLocationInput(
//                                 'PICKUP',
//                                 'Enter pickup location',
//                                 Icons.location_on,
//                                 Colors.blue,
//                                 apiKey: apiKey,
//                                 controller: _pickupController,
//                                 onLocationSelected: (LatLng location) {
//                                   setState(() {
//                                     _pickupLocation = location;
//                                   });
//                                 },
//                               ),
//                               _buildDottedLine(),
//                               // Drop Location
//                               _buildLocationInput(
//                                 'DROP',
//                                 'Enter drop location',
//                                 Icons.location_on,
//                                 Colors.orange,
//                                 apiKey: apiKey,
//                                 controller: _dropController,
//                                 onLocationSelected: (LatLng location) {
//                                   setState(() {
//                                     _dropLocation = location;
//                                   });
//                                 },
//                               ),
//                             ],
//                           )
//                         else
//                           Column(
//                             children: [
//                               // Pickup Location
//                               _buildLocationInput(
//                                 'PICKUP',
//                                 'Enter pickup location',
//                                 Icons.location_on,
//                                 Colors.blue,
//                                 apiKey: apiKey,
//                                 controller: _pickupController,
//                                 onLocationSelected: (LatLng location) {
//                                   setState(() {
//                                     _pickupLocation = location;
//                                   });
//                                 },
//                               ),
//                               // Stop Location
//                               _buildLocationInput(
//                                 'STOP',
//                                 'Enter stop location',
//                                 Icons.location_on,
//                                 Colors.green,
//                                 apiKey: apiKey,
//                                 controller: _stopController,
//                                 onLocationSelected: (LatLng location) {
//                                   setState(() {
//                                     _stopLocation = location;
//                                   });
//                                 },
//                               ),
//                               // Return Location
//                               _buildLocationInput(
//                                 'RETURN',
//                                 'Enter return location',
//                                 Icons.location_on,
//                                 Colors.red,
//                                 apiKey: apiKey,
//                                 controller: _returnController,
//                                 onLocationSelected: (LatLng location) {
//                                   setState(() {
//                                     _returnLocation = location;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         if (_tripDetails.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Trip Type: ${_tripDetails['type']}'),
//                                 if (isOneWaySelected) ...[
//                                   Text('Distance: ${_tripDetails['distance']}'),
//                                   Text('Duration: ${_tripDetails['duration']}'),
//                                 ] else ...[
//                                   Text(
//                                       'Total Distance: ${_tripDetails['total_distance']}'),
//                                   Text(
//                                       'Total Duration: ${_tripDetails['total_duration']}'),
//                                 ],
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTripTypeSelector() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildSelectableCard('One Way', isOneWaySelected, () {
//             setState(() {
//               isOneWaySelected = true;
//             });
//           }),
//           _buildSelectableCard('Return Trip*', !isOneWaySelected, () {
//             setState(() {
//               isOneWaySelected = false;
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildSelectableCard(
//       String title, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.grey,
//           ),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.blue : Colors.black,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationInput(
//     String label,
//     String hint,
//     IconData icon,
//     Color iconColor, {
//     required String apiKey,
//     required TextEditingController controller, // Add controller here
//     required Function(LatLng) onLocationSelected,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: TypeAheadField(
//         textFieldConfiguration: TextFieldConfiguration(
//           controller: controller, // Bind controller
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: hint,
//             prefixIcon: Icon(icon, color: iconColor),
//             border: const OutlineInputBorder(),
//           ),
//         ),
//         suggestionsCallback: (pattern) async {
//           return await _fetchPlaceSuggestions(pattern, apiKey);
//         },
//         itemBuilder: (context, suggestion) {
//           return ListTile(
//             title: Text(suggestion['description']),
//           );
//         },
//         onSuggestionSelected: (suggestion) async {
//           // Set the text into the input field
//           controller.text = suggestion['description'];

//           // Fetch LatLng and update the marker position
//           LatLng location =
//               await _getLatLngFromPlaceId(suggestion['place_id'], apiKey);
//           onLocationSelected(location);
//         },
//       ),
//     );
//   }

//   Widget _buildDottedLine() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: SizedBox(
//         height: 40,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(
//             4,
//             (index) => Container(
//               width: 4,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomButton() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () {
//           print("Trip confirmed with details:");
//           print("Pickup Location: $_pickupLocation");
//           print("Drop Location: $_dropLocation");
//           print("Stop Location: $_stopLocation");
//         },
//         child: const Text(
//           'CONFIRM TRIP',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// Existing imports...
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mrdrop/screens/home_screen.dart';
import 'package:mrdrop/screens/instantRideBook.dart';
// Your existing code...

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
  String? _totalDistance;
  String? _totalDuration;
  String? pickupPoint;
  String? stopPoint;
  String? dropPoint;
  LatLng? _stopPosition;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  LatLng? _stopLocation;
  LatLng? _returnLocation;
  bool isOneWaySelected = true;
  Set<Polyline> _polylines = {};
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final TextEditingController _stopController = TextEditingController();
  final TextEditingController _returnController = TextEditingController();

  Map<String, dynamic> _tripDetails = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
        "?place_id=$placeId&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'OK') {
          print("Google Place Details Error: ${data['status']}");
          return LatLng(0, 0); // Return default for failure
        }

        final location = data['result']['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        print("Fetched Location: Lat=$lat, Lng=$lng"); // Debug log

        return LatLng(lat, lng);
      } else {
        print("HTTP Error: ${response.statusCode}");
        return LatLng(0, 0);
      }
    } catch (e) {
      print("Exception in _getLatLngFromPlaceId: $e");
      return LatLng(0, 0);
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
    pickupPoint = "";
    dropPoint = "";
    stopPoint = "";
    _totalDistance = "";
    _totalDuration = "";
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

  Future<void> _getRouteAndDistance() async {
    if (_pickupLocation == null || _dropLocation == null) return;

    String waypoints = '';
    if (!isOneWaySelected && _stopLocation != null) {
      waypoints = '${_stopLocation!.latitude},${_stopLocation!.longitude}|';
    }

    // Include return location in the waypoints if needed
    String returnWaypoint = !isOneWaySelected && _returnLocation != null
        ? '${_returnLocation!.latitude},${_returnLocation!.longitude}'
        : '';
    print("Return Point is : ${returnWaypoint}");

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&'
        'destination=${_dropLocation!.latitude},${_dropLocation!.longitude}&'
        'waypoints=$waypoints&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final distance = route['legs'][0]['distance']['text'];
        final duration = route['legs'][0]['duration']['text'];
        final legs = route['legs'];
        double totalDistance = 0;
        double totalDuration = 0;

        for (var leg in legs) {
          totalDistance += leg['distance']['value'];
          totalDuration += leg['duration']['value']; // in seconds
        }

        setState(() {
          _tripDetails = {
            'type': isOneWaySelected ? 'One Way' : 'Return Trip',
            'distance': distance,
            'duration': duration,
            // 'total_distance': distance,
            // 'total_duration': duration,
            'total_distance': '${(totalDistance / 1000).toStringAsFixed(2)} km',
            'total_duration': '${(totalDuration / 60).toStringAsFixed(2)} min',
          };
        });
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          // Existing distance and duration logic...

          // Draw the route on the map
          _drawRoute(route['overview_polyline']
              ['points']); // Ensure this line is included
        }
      } else {
        print('Error in directions API: ${data['status']}');
      }
    } else {
      print('Failed to load directions: ${response.statusCode}');
    }
  }

  //Get Route and Distance if Return
  Future<void> _getRouteAndDistanceReturn() async {
    if (_pickupLocation == null ||
        _stopLocation == null ||
        _returnLocation == null) return;

    String waypoints = '';
    if (!isOneWaySelected && _stopLocation != null) {
      waypoints = '${_stopLocation!.latitude},${_stopLocation!.longitude}|';
    }

    print("Return Point is : ${waypoints}");

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&'
        'destination=${_returnLocation!.latitude},${_returnLocation!.longitude}&'
        'waypoints=$waypoints&key=AIzaSyBWUMiCnj-F_YfZcTqswcpu5JQVw5xXcCQ';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final distance = route['legs'][0]['distance']['text'];
        final duration = route['legs'][0]['duration']['text'];
        final legs = route['legs'];
        double totalDistance = 0;
        double totalDuration = 0;

        for (var leg in legs) {
          totalDistance += leg['distance']['value'];
          totalDuration += leg['duration']['value']; // in seconds
        }

        setState(() {
          _tripDetails = {
            'type': isOneWaySelected ? 'One Way' : 'Return Trip',
            'distance': distance,
            'duration': duration,
            // 'total_distance': distance,
            // 'total_duration': duration,
            'total_distance': '${(totalDistance / 1000).toStringAsFixed(2)} km',
            'total_duration': '${(totalDuration / 60).toStringAsFixed(2)} min',
          };

          pickupPoint = _pickupController.text;
          stopPoint = _stopController.text;
          dropPoint = _dropController.text;
          if (isOneWaySelected) {
            _totalDistance = distance;
            _totalDuration = duration;
          } else {
            _totalDistance = (totalDistance / 1000).toStringAsFixed(2);
            _totalDuration = (totalDuration / 60).toStringAsFixed(2);
          }
        });
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          // Existing distance and duration logic...

          // Draw the route on the map
          _drawRoute(route['overview_polyline']
              ['points']); // Ensure this line is included
        }
      } else {
        print('Error in directions API: ${data['status']}');
      }
    } else {
      print('Failed to load directions: ${response.statusCode}');
    }
  }

//Create a Logic to go to the taxi ride page
  void taxiRidesPage(String duration, String distance, String pickup,
      String drop, String stop, BuildContext context) {
    if (duration != "" && distance != "" && pickup != "" && drop != "") {
      //ToDo - Call new Page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstantRideBook(
                    distance: distance,
                    duration: duration,
                    drop: drop,
                    pickup: pickup,
                    stop: "",
                  )));
    } else if (duration != "" &&
        distance != "" &&
        pickup != "" &&
        drop != "" &&
        stop != "") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstantRideBook(
                    distance: distance,
                    duration: duration,
                    drop: drop,
                    pickup: pickup,
                    stop: stop,
                  )));
      //ToDo - Call new Page
    } else {
      //ToDo - show empty Toast
    }
  }

  // void _drawRoute(String encodedPoly) {
  //   setState(() {
  //     List<LatLng> polylineCoordinates = _convertToLatLng(encodedPoly);
  //     mapController.addPolyline(Polyline(
  //       polylineId: PolylineId('route'),
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 5,
  //     ));
  //   });
  // }

  // void _drawRoute(String encodedPoly) {
  //   List<LatLng> polylineCoordinates = _convertToLatLng(encodedPoly);
  //   setState(() {
  //     _polylines.add(Polyline(
  //       polylineId: PolylineId('route'),
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 5,
  //     ));
  //   });
  // }

  void _drawRoute(String encodedPoly) {
    List<LatLng> polylineCoordinates = _convertToLatLng(encodedPoly);
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      ));
    });
  }

  List<LatLng> _convertToLatLng(String encoded) {
    List<LatLng> coordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
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
              polylines: _polylines, // Use the polylines set here
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
                maxChildSize: 0.9,
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
                                'Enter pickup location',
                                Icons.location_on,
                                Colors.blue,
                                apiKey: apiKey,
                                controller: _pickupController,
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _pickupLocation = location;
                                  });
                                },
                              ),
                              _buildDottedLine(),
                              // Drop Location
                              _buildLocationInput(
                                'DROP',
                                'Enter drop location',
                                Icons.location_on,
                                Colors.orange,
                                apiKey: apiKey,
                                controller: _dropController,
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _dropLocation = location;
                                  });
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
                                'Enter pickup location',
                                Icons.location_on,
                                Colors.blue,
                                apiKey: apiKey,
                                controller: _pickupController,
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _pickupLocation = location;
                                  });
                                },
                              ),
                              // Stop Location
                              _buildLocationInput(
                                'STOP',
                                'Enter stop location',
                                Icons.location_on,
                                Colors.green,
                                apiKey: apiKey,
                                controller: _stopController,
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _stopLocation = location;
                                  });
                                },
                              ),
                              // Return Location
                              _buildLocationInput(
                                'RETURN',
                                'Enter return location',
                                Icons.location_on,
                                Colors.red,
                                apiKey: apiKey,
                                controller: _returnController,
                                onLocationSelected: (LatLng location) {
                                  setState(() {
                                    _returnLocation = location;
                                  });
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
    String hint,
    IconData icon,
    Color iconColor, {
    required String apiKey,
    required TextEditingController controller, // Add controller here
    required Function(LatLng) onLocationSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controller, // Bind controller
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: iconColor),
            border: const OutlineInputBorder(),
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
          // Set the text into the input field
          controller.text = suggestion['description'];

          // Fetch LatLng and update the marker position
          LatLng location =
              await _getLatLngFromPlaceId(suggestion['place_id'], apiKey);
          onLocationSelected(location);
        },
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
          if (_pickupLocation != null && _dropLocation != null) {
            _getRouteAndDistance();
            print("Trip confirmed with details:");
            print("Pickup Location: $_pickupLocation");
            print("Drop Location: $_dropLocation");
            print("Stop Location: $_stopLocation");
          } else if (_returnController != null &&
              _pickupLocation != null &&
              _stopController != null) {
            _getRouteAndDistanceReturn();
          } else {
            // Handle the case where locations are not set
            print("Pickup or drop location is not set.");
          }
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
