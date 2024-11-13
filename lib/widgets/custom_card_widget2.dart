import 'package:flutter/material.dart';

class CustomCardWidget2 extends StatelessWidget {
  const CustomCardWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    double rotationAngle2 = 3.09 * 3.14159 / 180;
    return Column(
      children: [
        Positioned(
          left: 20,
          child: Container(
            width: 390,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(5.146),
                colors: [
                  Color.fromRGBO(176, 214, 69, 1),
                  Color.fromRGBO(70, 241, 116, 1),
                ],
                stops: [0.174, 0.9203],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/Mr.DRop-2.png",
                          width: 115,
                          height: 30,
                        ),
                        Image.asset(
                          "assets/Mr.DRop-1.png",
                          width: 115,
                          height: 30,
                        ),
                        Image.asset(
                          "assets/Mr.DRop-2.png",
                          width: 115,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  child: Transform.rotate(
                    angle: rotationAngle2,
                    child: Opacity(
                      opacity: 1,
                      child: Image.asset(
                        "assets/Rectangle 59.png",
                        width: 257.73,
                        height: 263.47,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
