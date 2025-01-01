import 'package:flutter/material.dart';
import 'package:mrdrop/screens/MobileVerification.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width * 0.4,
                  MediaQuery.of(context).size.height * 0.25),
              painter: CornerPainter(),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 300,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.25),
                painter: CornerPainter(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                // Logo section
                Image.asset(
                  'assets/bgrlogo.png',
                  height: 200,
                  width: 200,
                ),

                const SizedBox(height: 10),

                SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                Column(
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Please select your language',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Language selection cards
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                _buildLanguageCard(context, 'Sinhala'),
                                const SizedBox(height: 15),
                                _buildLanguageCard(context, 'Tamil'),
                                const SizedBox(height: 15),
                                _buildLanguageCard(context, 'English'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Language selection text
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, String language) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MobileVerification()));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(117, 217, 217, 217),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            language,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for the corner shapes
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
