import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:csv/csv.dart';
import 'package:nokhwook/word.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void loadVocabulary() async {
    String vocab = await rootBundle.loadString('assets/vocab.csv');
    List<List<dynamic>> items = const CsvToListConverter().convert(vocab);
    List<dynamic> header = items.removeAt(0);

    // Data transformation functions.
    makeWordItem(index, v) => WordItem(lang: header[index], phrase: v);
    makeWordItems(entries) => entries.asMap().entries.map<WordItem>(
      (e) => makeWordItem(e.key, e.value)
    );

    List<Word<WordItem>> words = items.map<Word<WordItem>>((item) {
      Iterable<WordItem> wordItems = makeWordItems(item);
      return Word(
        header: wordItems.first,
        items: wordItems.skip(1).toList()
      );
    }).toList();

    // await Future.delayed(Duration(seconds: 5));

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'words': words}
      );
    }
  }

  @override
  void initState() {
    super.initState();
    
    loadVocabulary();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[400],
      child: const Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}