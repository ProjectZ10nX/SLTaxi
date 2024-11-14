import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const OptionTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: Colors.black,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: widget.subtitle != null
            ? Text(
                widget.subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 13,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
