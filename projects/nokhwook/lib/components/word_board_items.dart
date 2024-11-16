import 'package:flutter/material.dart';

enum HeadlineItemType { small, medium, large }

class HeadlineItem extends StatelessWidget {
  final HeadlineItemType type;
  final String title, text;
  const HeadlineItem(
      {super.key,
      required this.title,
      required this.text,
      this.type = HeadlineItemType.small});

  styles(context) {
    switch (type) {
      case HeadlineItemType.small:
        return Theme.of(context).textTheme.headlineSmall;
      case HeadlineItemType.medium:
      default:
        return Theme.of(context).textTheme.headlineMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      Text(
        text,
        textAlign: TextAlign.center,
        style: styles(context),
      )
    ]);
  }
}
