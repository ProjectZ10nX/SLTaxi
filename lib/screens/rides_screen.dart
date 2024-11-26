import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrdrop/screens/home_screen.dart';
import 'package:mrdrop/screens/rideSelect.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(6.9271, 79.8612);
  bool isOneWaySelected = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                onPressed: () {},
                icon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
              )
            ],
          ),
          // GoogleMap(
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _center,
          //     zoom: 15.0,
          //   ),
          // ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      _buildTripTypeSelector(),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isOneWaySelected)
                        Column(
                          children: [
                            _buildLocationInput('PICKUP', 'Location fetched',
                                Icons.favorite_border, Colors.blue),
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
                                        builder: (context) =>
                                            const Rideselect()));
                              },
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildLocationInput('PICKUP', 'Location fetched',
                                Icons.favorite_border, Colors.blue),
                            _buildLocationInput('STOP', 'Where are you going?',
                                Icons.abc, Colors.green),
                            _buildLocationInput(
                              'RETURN',
                              'Same as pickup',
                              Icons.add,
                              Colors.red,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Rideselect()));
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
}

Widget _buildSelectableCard(String title, bool isSelected, VoidCallback onTap) {
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
    String label, String placeholder, IconData icon, Color labelColor,
    {VoidCallback? onPressed}) {
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
            onPressed: () {},
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
                SizedBox(width: 12), // Adjust the width as needed for spacing
                Text(
                  'Later',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Icon(
          Icons.my_location,
          color: Colors.grey,
        )
      ],
    ),
  );
}
