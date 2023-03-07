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
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(width: 5.0),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge,
        )
      ]
    );
  }
}