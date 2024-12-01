import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrdrop/screens/EmailVerification.dart';
import 'package:mrdrop/screens/home_screen.dart';

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
  bool _isLoading = false;

  void _handleKeyPress(String value) {
    setState(() {
      _inputText += value;
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
  void checkEmailVerified(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc['isEmailVerified'] == "true") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() => _isLoading = false);
        print(
            "Profile Creation, Email Verification State is : ${userDoc['isEmailVerified']}");
      }
    } catch (e) {
      print("Error in Profile Creation is : ${e.toString()}");
    }
  }

  void _handleBackspace() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
      }
    });
  }

  Future<bool> _checkEmailAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = emailController.text.trim();
    if (user != null && email.isNotEmpty) {
      try {
        UserCredential tempUserCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: "Temporary@123",
        );

        // Send email verification
        User? tempUser = tempUserCredential.user;
        if (tempUser != null && !tempUser.emailVerified) {
          await tempUser.sendEmailVerification();
          print("Verification email sent to $email");
          return true;
        }
      } catch (e) {
        print("Error sending verification email: $e");
      }
    }

    return false;
  }

  void _userSubmit() async {
    try {
      setState(() => _isLoading = true);
      String fName = firstNameController.text.trim();
      String lName = lastNameController.text.trim();
      String email = emailController.text.trim();

      print("Attempting submission with email: $email");

      if (fName.isEmpty || lName.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid credentials")),
        );
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user is currently signed in")),
        );
        return;
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "id": user.uid,
        "email": email,
        "firstname": fName,
        "lastname": lName,
        "isEmailVerified": false,
      });

      print("User data saved to database");

      // Handle email verification
      bool emailVerificationStatus = false;
      try {
        emailVerificationStatus = await _checkEmailAuth();
      } catch (e) {
        print("Error is $e");
      }

      print("Email verification status: $emailVerificationStatus");

      if (emailVerificationStatus == true) {
        print("USER UID IN Profile Create Screen Is : ${user.uid}");
        String Id = user.uid;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerification(
                  Email: emailController.text.trim(), uid: Id)),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Error in user submission: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  double spacePadding = 5.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      checkEmailVerified(context);
    });
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
      floatingActionButton:
          _isLoading ? Center(child: CircularProgressIndicator()) : null,
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
