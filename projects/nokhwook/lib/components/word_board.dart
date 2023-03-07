import 'package:flutter/material.dart';
import 'package:nokhwook/models/word.dart';

class WordBoard extends StatelessWidget {
  final List<String> header;
  final Word word;
  final Function memorize;
  final List<TextStyle> styles = [
    TextStyle(fontSize: 30.0, color: Colors.red[400], letterSpacing: 2.0),
    TextStyle(fontSize: 16.0, color: Colors.grey[800], letterSpacing: 1.5)
  ];
  WordBoard(
      {super.key,
      required this.word,
      required this.memorize,
      required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              header.length,
              (index) => buildItem(header[index], word[index].phrase,
                  styles[index > 0 ? 1 : index]))),
    );
  }

  Widget buildItem(lang, phrase, style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          lang.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          phrase,
          style: style,
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
