import 'package:flutter/material.dart';

class OptionTitle extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const OptionTitle(
      {Key? key, required this.icon, required this.title, this.onTap})
      : super(key: key);

  @override
  State<OptionTitle> createState() => _OptionTitleState();
}

class _OptionTitleState extends State<OptionTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      child: Card(
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: Colors.black,
          ),
          minVerticalPadding: 15,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
