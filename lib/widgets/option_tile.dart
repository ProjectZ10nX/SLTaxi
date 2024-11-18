import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: Colors.black,
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: widget.subtitle != null
            ? Text(
                widget.subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 13,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
