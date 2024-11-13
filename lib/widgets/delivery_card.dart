import 'package:flutter/material.dart';

class DeliveryCard extends StatelessWidget {
  // ignore: use_super_parameters
  const DeliveryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rotationAngle = 3.09 * 3.14159 / 180;

    return Center(
      child: Container(
        width: 390,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 0.0),
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
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
            Align(
              alignment: Alignment.topLeft,
              child: Transform.rotate(
                angle: rotationAngle,
                child: Opacity(
                  opacity: 1.0,
                  child: Image.asset(
                    'assets/Rectangle 53.png',
                    width: 166.48,
                    height: 179.6,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'DELIVERING HAPPINESS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'DELIVERING HAPPINESS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'DELIVERING HAPPINESS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          buildTextContainer2(
                            '10K Drivers',
                          ),
                          const SizedBox(width: 10),
                          buildTextContainer2(
                            '20k Users',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextContainer2(String text) {
  return Container(
    width: 100,
    height: 60,
    decoration: BoxDecoration(
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 4),
          blurRadius: 4,
        ),
      ],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
        child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    )),
  );
}
