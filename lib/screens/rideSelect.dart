import 'package:flutter/material.dart';
import 'package:mrdrop/screens/rides_screen.dart';

class Rideselect extends StatefulWidget {
  const Rideselect({super.key});

  @override
  State<Rideselect> createState() => _RideselectState();
}

class _RideselectState extends State<Rideselect> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Components
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RidesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 130,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 163, 227, 67),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        color: Color.fromARGB(255, 103, 103, 103),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Book a friend",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Container(
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton("One Way", 0),
                _buildTabButton("Return Trip*", 1),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                    "PICKUP", "167, Negambo - Kurunagala Road...", true),
                const SizedBox(height: 8),
                // Conditionally render the STOP section
                if (selectedTab == 1)
                  _buildSection(
                    "STOP",
                    "Where are you going?",
                    true,
                    color: Colors.red,
                  ),
                const SizedBox(height: 8),

                // Update the DROP hint text based on the selected tab
                _buildSection(
                  "DROP",
                  selectedTab == 0 ? "Where are you going?" : "Same as pickup",
                  true,
                ),
                const SizedBox(height: 16),
                _buildOption(
                    Icons.favorite_border_outlined, "Favourites", null),
                const Divider(),
                _buildOption(
                    Icons.location_on_outlined, "Set Location on Map", null),
                const Divider(),
                _buildOption(Icons.home_outlined, "Add Home", Colors.black),
                const Divider(),
                _buildOption(
                    Icons.work_outline_outlined, "Add Work", Colors.black),
                const Divider(),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  selectedTab == index ? FontWeight.bold : FontWeight.normal,
              color: selectedTab == index ? Colors.black : Colors.grey,
            ),
          ),
          if (selectedTab == index)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 60,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String hintText, bool isEditable,
      {Color? color}) {
    return Row(
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
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
        if (title == "PICKUP")
          const Icon(
            Icons.close,
            size: 16,
            color: Colors.grey,
          ),
        if (title == "PICKUP")
          const Icon(
            Icons.favorite_outline,
            size: 16,
            color: Colors.grey,
          ),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title, Color? iconColor) {
    return ListTile(
      leading: iconColor != null
          ? Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 163, 227, 67),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: 18,
              ),
            )
          : Icon(
              icon,
              color: Colors.black,
            ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: title == "Favourites"
          ? const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: Colors.black,
            )
          : null,
    );
  }
}
