import 'package:flutter/material.dart';
import 'package:mrdrop/widgets/option_tile.dart';
import 'package:mrdrop/widgets/user_profile_section.dart';
import 'package:mrdrop/widgets/user_progress_card.dart';

class ProfileScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 2.0,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfileSection(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Title(
                      color: Colors.black,
                      child: const Text(
                        "Your Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const UserProgressCard(),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Your Information'),
                    OptionTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Add profile picture',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.person_add_alt_outlined,
                      title: 'Name',
                      subtitle: 'fname lname',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.phone_iphone,
                      title: 'Mobile',
                      subtitle: '0777123456',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.email_outlined,
                      title: 'E-mail',
                      subtitle: 'Add your e-mail',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.cake_outlined,
                      title: 'Birthday',
                      subtitle: 'Add your birthday',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.male_outlined,
                      title: 'Gender',
                      subtitle: 'Select gender',
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSectionTitle('Your Preferences'),
                    OptionTile(
                      icon: Icons.language,
                      title: 'Languages',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.emergency_outlined,
                      title: 'Emergency Contacts',
                      subtitle: 'Add emergency contact(s)',
                      onTap: () {},
                    ),
                    const Divider(),
                    OptionTile(
                      icon: Icons.settings,
                      title: 'Account',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32.0),
                    Center(
                      child: SizedBox(
                        width: 240,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 0.0,
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
