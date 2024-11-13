import 'package:flutter/material.dart';
import 'package:mrdrop/widgets/cutom_bottom_navbar.dart';
import 'package:mrdrop/widgets/user_profile_section.dart';
import 'package:mrdrop/widgets/user_progress_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileSection(),
            SizedBox(height: 5),
            UserProgressCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
