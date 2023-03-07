import 'package:flutter/material.dart';
import 'package:nokhwook/components/word_board.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatelessWidget {
  final Vocab vocab;

  const Welcome({super.key, required this.vocab});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, storeSnapshot) {
          List<int> subset = [];

          if (storeSnapshot.hasData) {
            subset =
                (storeSnapshot.data?.getStringList('memorized') ?? <String>[])
                    .toSet()
                    .map(int.parse)
                    .toList();
          }

          return Column(
            children: [
              Text('You have learnt ${subset.length} words'),
              Expanded(
                child: ListView.builder(
                  itemCount: subset.length,
                    itemBuilder: (context, index) => Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(10.0),
          color: Colors.grey[300],
          child: WordBoard(
                        word: vocab[index],
                        memorize: () => {},
                        header: vocab.header)),
              )),
            ],
          );
        });
  }
}
