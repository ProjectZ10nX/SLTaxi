import 'package:flutter/material.dart';
import 'package:mrdrop/widgets/cutom_bottom_navbar.dart';
import 'package:mrdrop/widgets/delivery_card.dart';
import 'package:mrdrop/widgets/option_title.dart';
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
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(),
              SizedBox(height: 5),
              UserProgressCard(),
              SizedBox(height: 10),
              DeliveryCard(),
              SizedBox(
                height: 20,
              ),
              OptionTitle(icon: Icons.card_membership, title: 'Memberships'),
              OptionTitle(icon: Icons.help_outline, title: 'Help and Support'),
              OptionTitle(icon: Icons.payment, title: 'Payment'),
              OptionTitle(icon: Icons.car_rental, title: 'Earn with SLTaxi'),
              OptionTitle(icon: Icons.info_outline, title: 'About Us'),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}
