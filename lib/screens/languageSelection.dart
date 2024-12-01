import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:mrdrop/screens/MobileVerification.dart';
import 'package:mrdrop/screens/home_screen.dart';
>>>>>>> Stashed changes

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

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
              size: Size(MediaQuery.of(context).size.width * 0.4,
                  MediaQuery.of(context).size.height * 0.25),
              painter: CornerPainter(),
            ),
          ),

          // Bottom green corner shape
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
                          topLeft: Radius.circular(
                              50), // Adjust the radius as needed
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
                                _buildLanguageCard('Sinhala'),
                                const SizedBox(height: 15),
                                _buildLanguageCard('Tamil'),
                                const SizedBox(height: 15),
                                _buildLanguageCard('English'),
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

  Widget _buildLanguageCard(String language) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
<<<<<<< Updated upstream
          // Handle language selection
=======
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
>>>>>>> Stashed changes
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
