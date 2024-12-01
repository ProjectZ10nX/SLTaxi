import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrdrop/screens/home_screen.dart';

class EmailVerification extends StatefulWidget {
  String? Email;
  String? uid;
  EmailVerification({super.key, required this.Email, required this.uid});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _isLoading = false;
  Timer? timer;

  String? email = "";
  String? id = "";

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    email = widget.Email;
    id = widget.uid;
    print("Email in initState is : ${email}");
    print("UID in initState is : ${id}");
    // Start verification check timer
    // timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //   _checkVerificationStatus();
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get email from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data()?['email'] != null) {
          final email = userDoc.data()!['email'] as String;

          // If email not set in Auth, set it
          if (user.email == null) {
            await user.verifyBeforeUpdateEmail(email);
          } else {
            await user.sendEmailVerification();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending verification email: $e')),
      );
    }
  }

//ToDo - refrase this method
  Future<void> _checkVerificationStatus() async {
    print("Email in Check Verification State is : ${email}");
    print("UID in Check Verification State : ${id}");
    try {
      final user = FirebaseAuth.instance.currentUser;
      print("Email Verified User's UID is : ${user!.uid}");
      String email = widget.Email.toString();

      if (user!.emailVerified) {
        try {
          print("UID From widget IS: ${widget.uid}");

          await FirebaseFirestore.instance.collection('users').doc(id).update({
            'isEmailVerified': "true",
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false, // Clears all previous routes
          );
          print("Email verification status updated in Firestore");
          deleteTemporaryUser(email);
        } catch (e) {
          print("Error updating Firestore: $e");
        }
      } else {
        print("USER isn't Email Verified");
      }

      if (user != null) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: "Temporary@123", // Use the temporary password
        );

        User? user = userCredential.user;
        if (user != null && user.emailVerified) {
          print("Email is verified : ${user.emailVerified.toString()}");
          await FirebaseFirestore.instance.collection('users').doc(id).update({
            'isEmailVerified': "true",
          });
          //Add UID from Widget
          String userUid = widget.uid.toString();
          //Print User UID is :
          print("User UID is : ${userUid}");
          await updateEmailVerificationStatus(userUid, true);

          String email = widget.Email.toString();
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .update({
              'isEmailVerified': "true",
            });
            print("Email verification status updated in Firestore");
            deleteTemporaryUser(email);
          } catch (e) {
            print("Error updating Firestore: $e");
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          print("Email is not verified : $email");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please verify your email first')),
          );
        }
      }
    } catch (e) {
      print('Error checking verification status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

//Update Verification Status
  Future<void> updateEmailVerificationStatus(
      String userId, bool isVerified) async {
    //Copied User isEmailVerified method
  }

//Delete Temporory User
  Future<void> deleteTemporaryUser(String email) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: "Temporary@123",
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.delete();
        print("Temporary user deleted");
      }
    } catch (e) {
      print("Error deleting temporary user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
            bottom: 250,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.25),
                painter: CornerPainter(),
              ),
            ),
          ),

          //Logo Section
          SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Image.asset(
                'assets/bgrlogo.png',
                height: 150,
                width: double.infinity,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              const Text(
                "Conform Your Email",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () async {
                  // Logout
                  await FirebaseAuth.instance.signOut();
                },
                child: Image.asset(
                  'assets/mail.png',
                  height: 150,
                  width: double.infinity,
                ),
              ),

              //Got it Button
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _checkVerificationStatus,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 220, 204, 198)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Set your desired radius here
                      ),
                    ),
                  ),
                  child: const Text(
                    "Ok, Got it",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ],
          )),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Didn't Get The Code"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: _resendVerificationEmail,
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("OR"),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: const Text("Change Email",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)))
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        ],
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
