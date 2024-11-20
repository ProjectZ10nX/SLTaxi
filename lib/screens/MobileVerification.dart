import 'package:flutter/material.dart';
import 'package:mrdrop/screens/VerificationCodeScreen.dart';
import 'package:mrdrop/services/firebase_service.dart';
import 'package:mrdrop/widgets/keyboard.dart';

class MobileVerification extends StatefulWidget {
  const MobileVerification({super.key});

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  String _inputText = "";
  String phoneNumber = '';
  List<DropdownMenuItem<dynamic>> items = [
    DropdownMenuItem(value: '+1', child: Text('USA (+1)')),
    DropdownMenuItem(value: '+44', child: Text('UK (+44)')),
    DropdownMenuItem(value: '+94', child: Text('Sri Lanka (+94)')),
  ];
  String _selectedCountryCode = '+94';
  bool _isLoading = false;

  TextEditingController phoneNumberController = TextEditingController();

  Future<void> _verifyPhone() async {
    if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number cannot be empty')),
      );
      return;
    }

    if (!RegExp(r'^\d{9,15}$').hasMatch(_inputText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await FirebaseService.verifyPhone(
      phoneNumber: '$_selectedCountryCode${_inputText}',
      onCodeSent: (String verificationId) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerificationCode(verificationId: verificationId),
          ),
        );
      },
      onError: (String error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
    );
  }

  dynamic countryChanged(dynamic value) {
    setState(() {
      _selectedCountryCode = value;
    });
    return value;
  }

  void _handleKeyPress(String value) {
    setState(() {
      _inputText += value;
      phoneNumberController.text = _inputText;
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
        phoneNumberController.text = _inputText;
      }
    });
  }

  double spacePadding = 5.0;

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
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Aligns content to top and keyboard to bottom
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
                    const Text("Enter Your Phone Number"),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please Enter Your Phone Number To Start Using MrDrop Services",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Row(
                        children: [
                          DropdownButton(
                            value: _selectedCountryCode,
                            items: items,
                            onChanged: countryChanged,
                            hint: const Text("+94"),
                          ),
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
                                    controller: phoneNumberController,
                                    keyboardType: TextInputType.none,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hintText: 'Enter phone number',
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
                        onPressed: _verifyPhone,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 189, 121, 96)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Set your desired radius here
                            ),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                // Custom Numeric Keyboard at the bottom
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomNumericKeyboard(
                      onKeyPressed: _handleKeyPress,
                      onBackspace: _handleBackspace,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Loading indicator
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
