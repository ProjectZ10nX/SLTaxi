import 'package:flutter/material.dart';

class InstantRideBook extends StatefulWidget {
  String? duration;
  String? distance;
  String? pickup;
  String? drop;
  String? stop;
  InstantRideBook(
      {super.key,
      required this.duration,
      required this.distance,
      required this.drop,
      required this.pickup,
      required this.stop});

  @override
  State<InstantRideBook> createState() => _InstantRideBookState();
}

class _InstantRideBookState extends State<InstantRideBook> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
