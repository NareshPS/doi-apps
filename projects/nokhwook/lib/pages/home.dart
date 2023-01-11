import 'package:flutter/material.dart';
import 'package:nokhwook/word.dart';
import 'package:nokhwook/components/word_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  int wordId = 0;
  List<Word<WordItem>> words = [];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    words = words.isEmpty? arguments['words']: words;

    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Let\'s practice'),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      body: WordCard(
        word: words[wordId],
        memorize: () {
          setState(() {
            words.removeAt(wordId);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        onPressed: () {
          setState(() {
            wordId = wordId >= words.length-1? 0: wordId + 1;
          });
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}