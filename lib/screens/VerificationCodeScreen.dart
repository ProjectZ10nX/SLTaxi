import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:flutter/material.dart';
import 'package:mrdrop/screens/EmailVerification.dart';
import 'package:mrdrop/screens/ProfileCreate.dart';
import 'package:mrdrop/screens/home_screen.dart';
import 'package:mrdrop/widgets/keyboard.dart'; // Your custom keyboard widget

class VerificationCode extends StatefulWidget {
  final String verificationId; // Verification ID received from Firebase

  const VerificationCode({super.key, required this.verificationId});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final TextEditingController firstNumberController = TextEditingController();
  final TextEditingController secondNumberController = TextEditingController();
  final TextEditingController thirdNumberController = TextEditingController();
  final TextEditingController fourthNumberController = TextEditingController();
  final TextEditingController fivethNumberController = TextEditingController();
  final TextEditingController sixethNumberController = TextEditingController();
  bool _isLoading = false;

  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  User? user = FirebaseAuth.instance.currentUser;
//Change this From here

  String? Email = "nomail";

  void _handleKeyPress(String value) {
    setState(() {
      for (int i = 0; i < controllers.length; i++) {
        if (controllers[i].text.isEmpty) {
          controllers[i].text = value;
          if (i < controllers.length - 1) {
            focusNodes[i + 1].requestFocus(); // Move to the next textbox
          }
          break;
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      for (int i = controllers.length - 1; i >= 0; i--) {
        if (controllers[i].text.isNotEmpty) {
          controllers[i].clear();
          focusNodes[i].requestFocus(); // Move focus to the current textbox
          break;
        } else if (i > 0 && controllers[i - 1].text.isNotEmpty) {
          controllers[i - 1].clear();
          focusNodes[i - 1]
              .requestFocus(); // Move focus to the previous textbox
          break;
        }
      }
    });
  }

  String? nullTxt = "null";
  Future<String?> _checkRegister() async {
    if (user != null) {
      // Get email from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      Email = userDoc.data()?['email'].toString();

      if (userDoc.exists && userDoc.data()?['email'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerification(
                    Email: Email,
                    uid: user!.uid,
                  )),
        );

        nullTxt = Email;
        return nullTxt;
      } else {
        return nullTxt;
      }
    }
    return nullTxt;
  }

  // Combine OTP from the text controllers
  String _getEnteredOTP() {
    return controllers.map((controller) => controller.text).join();
  }

  Future<bool> _checkEmailVerified() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print("User's UID in Verification Code Screen is : ${user!.uid}");
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      print(userDoc['isEmailVerified']);
      if (userDoc['isEmailVerified'] == "true") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      return true;
    } catch (e) {
      print("Error In Verification Code Screen Is : ${e.toString()}");
      return false;
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    _checkRegister();
    bool checkverified = await _checkEmailVerified();
    if (checkverified == true) {}
    print("Null text is : ");
    print(nullTxt);
    String enteredOTP = _getEnteredOTP();

    if (enteredOTP.length != 6) {
      // Show error if OTP is incomplete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return;
    }

    try {
      // Use Firebase to verify the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: enteredOTP,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      //ToDo - Change this as if user account already created send him to Email Verification Screen
      final user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        if (nullTxt == "null") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileCreatePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                //Change Email Verificatio to AuthWrapper
                builder: (context) => EmailVerification(
                      Email: Email,
                      uid: user!.uid,
                    )),
          );
        }
      }
    } catch (e) {
      // Show error if OTP verification fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP: $e")),
      );
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

          Positioned(
            left: 0,
            bottom: 250,
            child: Transform.rotate(
              angle: 3.14159,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    // Logo section
                    Image.asset(
                      'assets/bgrlogo.png',
                      height: 100,
                      width: double.infinity,
                    ),
                    const Text("Verification Code"),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Enter The Verification Code Which Has Been Sent To You",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _otpTextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _actionButton(
                          label: "Back",
                          color: const Color.fromARGB(255, 220, 204, 198),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        _actionButton(
                          label: "Next",
                          color: const Color.fromARGB(255, 189, 121, 96),
                          onPressed: _verifyOTP,
                        ),
                      ],
                    ),
                  ],
                ),

                // Custom Numeric Keyboard at the bottom
                SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomNumericKeyboard(
                        onKeyPressed: _handleKeyPress,
                        onBackspace: _handleBackspace,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          _isLoading ? Center(child: CircularProgressIndicator()) : null,
    );
  }

  // Widget _otpTextField(TextEditingController controller) {
  //   return Expanded(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey[200],
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: TextField(
  //         controller: controller,
  //         keyboardType: TextInputType.number,
  //         maxLength: 1,
  //         textAlign: TextAlign.center,
  //         decoration: const InputDecoration(
  //           border: InputBorder.none,
  //           counterText: "",
  //           contentPadding: EdgeInsets.symmetric(
  //             vertical: 12,
  //           ),
  //         ),
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _otpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        readOnly: true, // Disable native keyboard
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }

  Widget _actionButton(
      {required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 20, 86, 209)
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
