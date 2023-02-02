import 'package:flutter/material.dart';

class SimpleInfo extends StatelessWidget {
  final String title;
  final String value;

  const SimpleInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          value,
          style: TextStyle(
            color: Colors.green[600],
            letterSpacing: 1.15,
            fontWeight: FontWeight.w600
          ),
        )
      ]
    );
  }
}