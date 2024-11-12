import 'package:flutter/material.dart';
import 'package:mrdrop/widgets/card_widget.dart';
import 'package:mrdrop/widgets/custom_card_widget.dart';
import 'package:mrdrop/widgets/custom_card_widget2.dart';
import 'package:mrdrop/widgets/cutom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove the shadow for a cleaner look
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Hi first name,",
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
          padding: const EdgeInsets.only(
              right: 2.0, top: 16.0), // Adjust the position of the logo
          child: Align(
            alignment: Alignment.topRight, // Align to the top right corner
            child: Image.asset(
              'assets/mrdrop.png',
              height: 120,
              width: 120,
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
              (TextField(
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
              )),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardWidget(asset: "assets/car.png", label: "Rides"),
                  CardWidget(asset: "assets/rentals.png", label: "Rentals"),
                  CardWidget(asset: "assets/flash.png", label: "Flash"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CardWidget(asset: "assets/scan.png", label: "Scan N' Go"),
                  CardWidget(asset: "assets/market.png", label: "Market")
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
