import 'package:flutter/material.dart';

class UserProgressCard extends StatefulWidget {
  const UserProgressCard({super.key});

  @override
  State<UserProgressCard> createState() => _UserProgressCardState();
}

class _UserProgressCardState extends State<UserProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Centers the container in its parent widget
      child: Container(
        width: 390,
        height: 130,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey, // Gray outline
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns children to the start
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Places 'complete now' at the end
              children: [
                Row(
                  children: [
                    Text(
                      '5 of 10 ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'complete',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromRGBO(4, 197, 56, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'complete now',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color.fromRGBO(4, 197, 56, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Adds spacing before the progress bar
            Container(
              width: 380, // Specifies the width of the progress bar
              height: 3, // Sets the height of the progress bar
              decoration: BoxDecoration(
                color:
                    Colors.grey[300], // Background color for the progress bar
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 190, // Represents 50% progress (half of 198px)
                  height: 3,
                  color:
                      const Color.fromRGBO(4, 197, 56, 1), // Progress bar color
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Adds spacing before the additional text
            const Text(
              'Additional information you give will help us provide you with a more personalised experience',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
