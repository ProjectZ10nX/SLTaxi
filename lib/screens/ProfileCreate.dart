import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrdrop/screens/EmailVerification.dart';

class ProfileCreatePage extends StatefulWidget {
  const ProfileCreatePage({super.key});

  @override
  State<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends State<ProfileCreatePage> {
  String _inputText = "";
  String phoneNumber = '';
  List<DropdownMenuItem<dynamic>> items = [];

  dynamic countryChanged(dynamic value) {
    return value;
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void _handleKeyPress(String value) {
    setState(() {
      _inputText += value;
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
      }
    });
  }

  void _userSubmit() async {
    String fName = firstNameController.text;
    String lName = lastNameController.text;
    String email = emailController.text;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (fName == "" || lName == "" || email == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid credentials")),
      );
    } else {
      User? user = auth.currentUser;

      if (user != null) {
        // User is signed in, retrieve the UID
        String uid = user.uid;

        String firstName = fName;
        String lastName = lName;

        Map<String, dynamic> userData = {
          "id": uid, // User's UID
          "email": email, // User's email
          "firstname": firstName,
          "lastname": lastName,
        };
        //New Method Start

        try {
          // Save data to Firestore using UID as document ID
          await firestore.collection('users').doc(uid).set(userData);

          //Redirect User to Conform your Email Screen

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EmailVerification()),
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          print("Error adding user details: $e");
        }

        //New Method End
      } else {
        // No user is signed in
        print("No user is currently signed in.");
      }
    }
  }

  double spacePadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Top green corner shape
            Positioned(
              right: 0,
              top: 0,
              child: CustomPaint(
                size: const Size(150, 170),
                painter: CornerPainter(),
              ),
            ),

            // Bottom green corner shape
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 3.14159, // 180 degrees in radians
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.height * 0.25),
                  painter: CornerPainter(),
                ),
              ),
            ),

            // Main content with keyboard aligned to bottom
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns content to top and keyboard to bottom
                children: [
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                      // Logo section
                      Image.asset(
                        'assets/bgrlogo.png',
                        height: 100,
                        width: double.infinity,
                      ),
                      const Text("Create Your Profile"),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Enter Your Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ),

                      const SizedBox(height: 100),
                      //First Name
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 20),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: firstNameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        hintText: 'Enter First Name',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Last Name
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 20),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: lastNameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        hintText: 'Enter Last Name',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Email
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 20),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        hintText: 'Enter Email Address',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _userSubmit,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 189, 121, 96)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Set your desired radius here
                              ),
                            ),
                          ),
                          child: const Text(
                            "DONE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB4E66E) // Light green color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
