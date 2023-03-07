import 'package:flutter/material.dart';
import 'package:nokhwook/components/stage_controls.dart';
import 'package:nokhwook/features/stages/stage_iterator.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/components/word_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stage extends StatefulWidget {
  final Vocab vocab;
  final String title;
  List<int>? subset;
  Stream<int>? currentWord;

  Stage(
      {super.key,
      required this.vocab,
      required this.title,
      this.currentWord,
      this.subset});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> with AutomaticKeepAliveClientMixin {
  int wordId = 0;

  late StageIterator stageIterator;

  @override
  void initState() {
    super.initState();
    stageIterator = StageIterator(widget.vocab.length, indices: widget.subset);
    widget.currentWord?.listen((wId) {
      setState(() => stageIterator.reset(wId));
    });
    logger.i('initState');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          color: Colors.grey[300],
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              Text(
                '${widget.title.toUpperCase()} ${stageIterator.current}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                ),
              ),
              WordBoard(
                header: widget.vocab.header,
                word: widget.vocab[stageIterator.current],
                memorize: () {},
                // TODO
                // memorize: () => setState(() => widget.words.removeAt(wordId)),
              ),
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Set<String> memorized =
                                (snapshot.data?.getStringList('memorized') ??
                                        <String>[])
                                    .toSet();
                            memorized.add(stageIterator.current.toString());
                            snapshot.data?.setStringList(
                                'memorized', memorized.toList());

                            setState(() {
                              stageIterator.moveNext();
                              // wordId = stageIterator.current;
                            });
                          },
                          icon: Icon(Icons.save, color: Colors.red[400]),
                        )
                      ],
                    );
                  }
                  return const Text('');
                },
              )
            ],
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        //   child: StageControls(
        //     actions: {
        //       // TODO
        //       // 'next': () => setState(() => wordId = nextWord.get(widget.words))
        //       'next': () {}
        //     },
        //   ),
        // ),
      ],
    );
  }
}
