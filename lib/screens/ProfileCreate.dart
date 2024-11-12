import 'package:flutter/material.dart';

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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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

                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "DONE",
                          style: TextStyle(color: Colors.white),
                        ),
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
                      ),
                    ),
                  ],
                ),
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
