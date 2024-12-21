import 'package:flutter/material.dart';
import 'package:mrdrop/screens/home_screen.dart';

class RentalsScreen extends StatefulWidget {
  const RentalsScreen({super.key});

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  bool _isSwitched = false;
  String _selectedVehicle = "Mini";
  String _selectedTab = "Hours";
  int _selectedIndex = 0;

  final List<Map<String, String>> _pricingOptions = [
    {"time": "1 Hour", "distance": "5 Km", "price": "LKR 800.00"},
    {"time": "2 Hours", "distance": "10 Km", "price": "LKR 1,500.00"},
    {"time": "3 Hours", "distance": "15 Km", "price": "LKR 2,200.00"},
    {"time": "4 Hours", "distance": "20 Km", "price": "LKR 2,800.00"},
    {"time": "5 Hours", "distance": "25 Km", "price": "LKR 3,500.00"},
    {"time": "6 Hours", "distance": "30 Km", "price": "LKR 4,000.00"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Rentals',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 195),
                Image.asset(
                  "assets/rentals.png",
                  height: 50,
                  width: 50,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOption(
                      "PICKUP", "167, Negambo - Kurunagala Road...", true),
                  const SizedBox(height: 8),
                  _buildOption(
                    "DROP",
                    "Where are you going?",
                    true,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 15),
                  // Overriding padding for the green container
                  Padding(
                    padding:
                        EdgeInsets.zero, // No padding for the green container
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent.shade100,
                      ),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Enter your destination to view suitable packages for your trip.",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  _isSwitched = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVehicleCard("Mini", "assets/mini_car_outline.png", 3),
                _buildVehicleCard("Car", "assets/car_outline.png", 4),
                _buildVehicleCard("Van", "assets/van_outline.png", 5),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab("Hours", isSelected: _selectedTab == "Hours"),
                _buildTab("Days", isSelected: _selectedTab == "Days"),
                _buildTab("Special", isSelected: _selectedTab == "Special"),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: _pricingOptions.length,
              itemBuilder: (context, index) {
                final option = _pricingOptions[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Colors.green.shade100
                          : Colors.white,
                      border: Border.all(
                        color: _selectedIndex == index
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              option["time"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          option["distance"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          option["price"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 400,
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
                                ),
                                child: const Text(
                                  'Schedule a rental',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  'Your ride will arrive on the date and time set blow (SriLanka TimeZone)',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, String hintText, bool isEditable,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 30,
        right: 30,
      ), // Padding applied globally for _buildOption widgets
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.green,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: title == "PICKUP" ? Colors.black : Colors.grey,
                ),
                border: const UnderlineInputBorder(),
              ),
            ),
          ),
          if (title == "PICKUP")
            Icon(
              Icons.favorite_outline,
              size: 16,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(String type, String iconPath, int capacity) {
    bool isSelected = _selectedVehicle == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicle = type;
        });
      },
      child: AnimatedContainer(
        width: 115,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              height: 50,
              color: isSelected ? Colors.green : Colors.black,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.green : Colors.black,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.person,
                  size: 12,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  "$capacity",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.green : Colors.black,
        ),
      ),
    );
  }
}
