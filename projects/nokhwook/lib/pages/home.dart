
import 'package:flutter/material.dart';
import 'package:nokhwook/pages/side_bar.dart';
import 'package:nokhwook/pages/stage.dart';
import 'package:nokhwook/utils/subset.dart';
import 'package:nokhwook/utils/word.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    List<Word<WordItem>> words = arguments['words'];
    List<int> subset = arguments['subset'];
    String category = arguments['category'] ?? 'Home';

    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Let\'s practice'),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      drawer: SideBar(words: words),
      body: Stage(
        title: category,
        words: WordSubset(words: words).resolve(subset)
      ),
    );
  }
}