// import 'package:flutter/material.dart';
// import 'package:mrdrop/widgets/keyboard.dart';

// class VerificationCode extends StatefulWidget {
//   const VerificationCode({super.key, required String verificationId});

//   @override
//   State<VerificationCode> createState() => _VerificationCodeState();
// }

// class _VerificationCodeState extends State<VerificationCode> {
//   String _inputText = "";
//   String phoneNumber = '';
//   List<DropdownMenuItem<dynamic>> items = [];

//   dynamic countryChanged(dynamic value) {
//     return value;
//   }

//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController firstNumberController = TextEditingController();
//   TextEditingController secondNumberController = TextEditingController();
//   TextEditingController thirdNumberController = TextEditingController();
//   TextEditingController fourthNumberController = TextEditingController();
//   TextEditingController fivethNumberController = TextEditingController();
//   TextEditingController sixethNumberController = TextEditingController();

//   void _handleKeyPress(String value) {
//     setState(() {
//       _inputText += value;
//     });
//   }

//   void _handleBackspace() {
//     setState(() {
//       if (_inputText.isNotEmpty) {
//         _inputText = _inputText.substring(0, _inputText.length - 1);
//       }
//     });
//   }

//   double spacePadding = 5.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Top green corner shape
//           Positioned(
//             right: 0,
//             top: 0,
//             child: CustomPaint(
//               size: const Size(150, 170),
//               painter: CornerPainter(),
//             ),
//           ),

//           // Bottom green corner shape
//           Positioned(
//             left: 0,
//             bottom: 250,
//             child: Transform.rotate(
//               angle: 3.14159, // 180 degrees in radians
//               child: CustomPaint(
//                 size: Size(MediaQuery.of(context).size.width * 0.4,
//                     MediaQuery.of(context).size.height * 0.25),
//                 painter: CornerPainter(),
//               ),
//             ),
//           ),

//           // Main content with keyboard aligned to bottom
//           SafeArea(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment
//                   .spaceBetween, // Aligns content to top and keyboard to bottom
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//                     // Logo section
//                     Image.asset(
//                       'assets/bgrlogo.png',
//                       height: 100,
//                       width: double.infinity,
//                     ),
//                     const Text("Verification Code"),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Enter The Verification Code Which Has Being Sent To You",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.w100),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Padding(
//                       padding: const EdgeInsets.all(50.0),
//                       child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           //First Number Box
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: firstNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           //Second Number Controller
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: secondNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           //Third Number Controller
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: thirdNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           //Fourth Number Controller
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: fourthNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           //Fiveth Number Controller
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: fivethNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(
//                             width: 10,
//                           ),

//                           //Sixeth Number Controller
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: sixethNumberController,
//                                     keyboardType: TextInputType.none,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ButtonStyle(
//                               backgroundColor: WidgetStateProperty.all<Color>(
//                                   const Color.fromARGB(255, 220, 204, 198)),
//                               shape: WidgetStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       12.0), // Set your desired radius here
//                                 ),
//                               ),
//                             ),
//                             child: const Text(
//                               "Back",
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 0, 0, 0)),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 150,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ButtonStyle(
//                               backgroundColor: WidgetStateProperty.all<Color>(
//                                   const Color.fromARGB(255, 189, 121, 96)),
//                               shape: WidgetStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       12.0), // Set your desired radius here
//                                 ),
//                               ),
//                             ),
//                             child: const Text(
//                               "Next",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 // Custom Numeric Keyboard at the bottom
//                 SingleChildScrollView(
//                   child: Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CustomNumericKeyboard(
//                         onKeyPressed: _handleKeyPress,
//                         onBackspace: _handleBackspace,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CornerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFB4E66E) // Light green color
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height)
//       ..close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:flutter/material.dart';
import 'package:mrdrop/screens/EmailVerification.dart';
import 'package:mrdrop/screens/ProfileCreate.dart';
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

  User? user = FirebaseAuth.instance.currentUser;
//Change this From here

  String _inputText = "";
  String? Email = "nomail";

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
    return firstNumberController.text +
        secondNumberController.text +
        thirdNumberController.text +
        fourthNumberController.text +
        fivethNumberController.text +
        sixethNumberController.text;
  }

  Future<void> _verifyOTP() async {
    _checkRegister();

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

      if (nullTxt == "null") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileCreatePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerification(
                    Email: Email,
                    uid: user!.uid,
                  )),
        );
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Row(
                        children: [
                          _otpTextField(firstNumberController),
                          const SizedBox(width: 10),
                          _otpTextField(secondNumberController),
                          const SizedBox(width: 10),
                          _otpTextField(thirdNumberController),
                          const SizedBox(width: 10),
                          _otpTextField(fourthNumberController),
                          const SizedBox(width: 10),
                          _otpTextField(fivethNumberController),
                          const SizedBox(width: 10),
                          _otpTextField(sixethNumberController),
                        ],
                      ),
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
    );
  }

  Widget _otpTextField(TextEditingController controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
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
      ..color = const Color(0xFFB4E66E)
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
