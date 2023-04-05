import 'package:flutter/material.dart';
import 'package:nokhwook/components/word_board.dart';
import 'package:nokhwook/models/vocab.dart';

class WordStage extends StatelessWidget {
  final Vocab vocab;
  final int? wordId;
  const WordStage({super.key, required this.vocab, required this.wordId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Word of the Day'.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          WordBoard(
            header: vocab.header,
            word: vocab[wordId!],
            memorize: () {},
          ),
        ],
      ),
    );
  }
}
