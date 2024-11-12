import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String asset;
  final String label;

  // ignore: use_super_parameters
  const CardWidget({Key? key, required this.asset, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xD9D9D9D9), // RGBA equivalent of rgba(217, 217, 217, 0)
                Color(0xFFFFFFFF), // #FFFFFF
                Color(0xFFC5F146), // #C5F146
              ],
              stops: [0.2508, 0.7012, 1.0411],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              asset,
              width: 73, // Adjust icon size if needed
              height: 59,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(86, 82, 84, 1),
          ),
        )
      ],
    );
  }
}
