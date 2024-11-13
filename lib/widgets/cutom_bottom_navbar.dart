import 'package:flutter/material.dart';
import 'package:mrdrop/screens/account_screen.dart';
import 'package:mrdrop/screens/home_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  // ignore: use_super_parameters
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430, // Width specified by you
      height: 68, // Height specified by you
      decoration: const BoxDecoration(
        color: Colors.white, // Background color of the bottom bar
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16), // Optional, for rounded corners
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Slight shadow for a raised look
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 22.0), // Left padding to position
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Image.asset(
                'assets/Home.png',
                width: 34,
                height: 34,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/Menu.png',
                width: 34,
                height: 34,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/Notification.png',
                width: 34,
                height: 34,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              },
              child: Image.asset(
                'assets/Account.png',
                width: 34,
                height: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
