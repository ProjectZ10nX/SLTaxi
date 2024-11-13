import 'package:flutter/material.dart';

class CustomNumericKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onBackspace;
  final double buttonSpacing;

  const CustomNumericKeyboard({
    Key? key,
    required this.onKeyPressed,
    required this.onBackspace,
    this.buttonSpacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate button size based on available width
        double buttonWidth = (constraints.maxWidth - (buttonSpacing * 5)) / 3;
        double buttonHeight = buttonWidth * 0.5; // Aspect ratio for buttons

        return Container(
          padding: EdgeInsets.all(buttonSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKeyboardRow(['1', '2', '3'], buttonWidth, buttonHeight),
              SizedBox(height: buttonSpacing),
              _buildKeyboardRow(['4', '5', '6'], buttonWidth, buttonHeight),
              SizedBox(height: buttonSpacing),
              _buildKeyboardRow(['7', '8', '9'], buttonWidth, buttonHeight),
              SizedBox(height: buttonSpacing),
              _buildLastRow(buttonWidth, buttonHeight),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyboardRow(
      List<String> keys, double buttonWidth, double buttonHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys
          .map((key) => _buildKeyboardButton(
                key,
                buttonWidth,
                buttonHeight,
                onPressed: () => onKeyPressed(key),
              ))
          .toList(),
    );
  }

  Widget _buildLastRow(double buttonWidth, double buttonHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildKeyboardButton(
          '+  #',
          buttonWidth,
          buttonHeight,
          onPressed: () => onKeyPressed('#'),
        ),
        _buildKeyboardButton(
          '0',
          buttonWidth,
          buttonHeight,
          onPressed: () => onKeyPressed('0'),
        ),
        _buildKeyboardButton(
          '⌫',
          buttonWidth,
          buttonHeight,
          onPressed: onBackspace,
          isBackspace: true,
        ),
      ],
    );
  }

  Widget _buildKeyboardButton(
    String text,
    double width,
    double height, {
    required VoidCallback onPressed,
    bool isBackspace = false,
  }) {
    return Container(
      width: width,
      height: height,
      child: Material(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  text == '5' ? Border.all(color: Colors.blue, width: 2) : null,
            ),
            child: Center(
              child: isBackspace
                  ? Icon(Icons.backspace_outlined,
                      size: 24, color: Colors.black54)
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: width * 0.4,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(221, 29, 27, 27),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
