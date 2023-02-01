import 'package:flutter/material.dart';
import 'package:nokhwook/utils/word.dart';

class WordBoard extends StatelessWidget {
  final Word<WordItem> word;
  final Function memorize;
  final List<TextStyle> styles = [
    TextStyle(
      fontSize: 30.0,
      color: Colors.red[400],
      letterSpacing: 2.0
    ),
    TextStyle(
      fontSize: 16.0,
      color: Colors.grey[800],
      letterSpacing: 1.5
    )
  ];
  WordBoard({super.key, required this.word, required this.memorize});

  @override
  Widget build(BuildContext context) {
    Widget header = buildItem(word.header, styles[0]);
    Widget buildEntry(WordItem item) => buildItem(item, styles[1]);
    List<Widget> items = word.items.map(buildEntry).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [header] + items,
      ),
    );
  }

  Widget buildItem(item, style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          item.lang.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          item.phrase,
          style: style,
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}