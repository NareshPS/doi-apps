import 'package:flutter/material.dart';
import 'package:nokhwook/components/stage_controls.dart';
import 'package:nokhwook/components/toggle_icon_button.dart';
import 'package:nokhwook/utils/next_word.dart';
import 'package:nokhwook/utils/word.dart';
import 'package:nokhwook/components/word_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stage extends StatefulWidget {
  final List<Word<WordItem>> words;
  final String title;
  
  const Stage({super.key, required this.words, required this.title});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage>{
  int wordId = 0;
  NextWord nextWord = OrderedNext();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.title.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                ),
              ),
              WordBoard(
                word: widget.words[wordId],
                memorize: () => setState(() => widget.words.removeAt(wordId)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleIconButton(
                    iconData: Icons.shuffle,
                    onOn: () => setState(() => nextWord = RandomNext()),
                    onOff: () => setState(() => nextWord = OrderedNext()),
                  ),

                  const SizedBox(height: 16.0),
                  FutureBuilder<SharedPreferences?>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TextButton.icon(
                          onPressed: () {
                            Set<String> memorized = (snapshot.data?.getStringList('memorized') ?? <String>[]).toSet();
                            memorized.add(wordId.toString());
                            snapshot.data?.setStringList('memorized', memorized.toList());
                            
                            setState(() {
                              widget.words.removeAt(wordId);
                            });
                          },
                          icon: Icon(Icons.hide_source_outlined, color: Colors.red[400]),
                          label: Text('Hide', style: TextStyle(color: Colors.red[400])),
                        );
                      }
                      else {
                        return TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.hide_source_outlined, color: Colors.grey[600]),
                          label: Text('Hide', style: TextStyle(color: Colors.grey[600])),
                        );
                      }
                    }
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          child: StageControls(
            actions: {
              'next': () => setState(() => wordId = nextWord.get(widget.words))
            },
          ),
        ),
      ],
    );
  }
}