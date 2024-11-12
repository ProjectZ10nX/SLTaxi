import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  // ignore: use_super_parameters
  const CustomCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rotationAngle = 3.09 * 3.14159 / 180;

    return Column(
      // Allow the image to overflow
      children: [
        // The main container card
        Positioned(
          left: 20,
          child: Container(
            width: 390,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(5.146), // Angle in radians
                colors: [
                  Color.fromRGBO(176, 214, 69, 1),
                  Color(0xFF46F174),
                ],
                stops: [0.174, 0.9203], // Positions in the gradient
              ),
            ),
            child: Row(
              children: [
                // Image on the left side (overflowing from the container)
                Align(
                  alignment: Alignment.topLeft,
                  child: Transform.rotate(
                    angle: rotationAngle, // Convert to radians
                    child: Opacity(
                      opacity: 1.0, // Set the image opacity to 1 for visibility
                      child: Image.asset(
                        'assets/Rectangle 53.png', // Replace with your image
                        width: 236.48,
                        height: 249.6,
                      ),
                    ),
                  ),
                ),
                // Right side: Texts with small container wrapping
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Delivering\nHappiness',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              // Text containers with specific background and styles
                              buildTextContainer('10K Drivers'),
                              const SizedBox(height: 10),
                              buildTextContainer('20K Users'),
                              const SizedBox(height: 10),
                              buildTextContainer('10K Drivers'),
                              const SizedBox(height: 10),
                              buildTextContainer('10K Drivers'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextContainer(String text) {
    return Container(
      width: 100,
      height: 20,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(170, 235, 123, 1), // rgba(170, 235, 123, 1)
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
