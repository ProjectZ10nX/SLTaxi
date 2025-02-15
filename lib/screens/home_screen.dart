//New Code
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrdrop/main.dart';
import 'package:mrdrop/screens/rentals_screen.dart';
import 'package:mrdrop/screens/rides_screen.dart';
import 'package:mrdrop/services/AppUser.dart';
import 'package:mrdrop/services/firebase_service.dart';
import 'package:mrdrop/widgets/card_widget.dart';
import 'package:mrdrop/widgets/custom_card_widget.dart';
import 'package:mrdrop/widgets/custom_card_widget2.dart';
import 'package:mrdrop/widgets/cutom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String userName = '';
String userEmail = '';

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Fetch user details once when the widget is initialized.
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      try {
        AppUser? currentUser = await FirebaseService.currentUser(userID);
        setState(() {
          userName = currentUser?.firstname ?? "";
        });
      } catch (e) {
        print("Error is: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Hi $userName",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "\nGood Evening",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(right: 2.0, top: 16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
                setState(() {}); // Not necessary here but safe.
              },
              child: Image.asset(
                'assets/sltaxi.png',
                height: 120,
                width: 120,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Where are you going?',
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(86, 82, 84, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(217, 217, 217, 0.46),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RidesScreen()),
                      );
                    },
                    child: const CardWidget(
                      asset: "assets/car.png",
                      label: "Rides",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RentalsScreen()),
                      );
                    },
                    child: const CardWidget(
                      asset: "assets/rentals.png",
                      label: "Rentals",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const CardWidget(
                      asset: "assets/flash.png",
                      label: "Flash",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CardWidget(
                      asset: "assets/scan.png",
                      label: "Scan N' Go",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const CardWidget(
                      asset: "assets/market.png",
                      label: "Market",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const CustomCardWidget(),
              const SizedBox(height: 30),
              const CustomCardWidget2(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
