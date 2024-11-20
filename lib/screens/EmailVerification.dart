import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  Future<bool> _checkEmailAuth() async {
    bool isAuth = false;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // UID is used as the document ID
            .get();

        if (userDoc.exists) {
          // Check if the email field exists in the document
          String? email = userDoc['email'];

          if (email != null) {
            // Update the user's email in Firebase Authentication
            await user.verifyBeforeUpdateEmail(email);

            // Send the verification email
            await user.sendEmailVerification();

            // Send the verification email
            await user.sendEmailVerification();

            print("Verification email sent to $email!");

            return isAuth = true;
          } else {
            print("Email field is missing in the Firestore document.");
            return isAuth = false;
          }
        } else {
          print("UserDoc Doesn't Exists!");
          return isAuth = false;
        }
      } else {
        print("No user is currently logged in.");
        return isAuth = false;
      }
    } catch (e) {
      print("Error sending verification email: $e");
    }
    return isAuth = false;
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
              Image.asset(
                'assets/mail.png',
                height: 150,
                width: double.infinity,
              ),

              //Got it Button
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _checkEmailAuth,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 220, 204, 198)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                        onTap: () {},
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
