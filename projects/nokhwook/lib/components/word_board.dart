import 'package:flutter/material.dart';
import 'package:nokhwook/models/word.dart';
import 'package:nokhwook/services/subtitles_service.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class WordBoard extends StatelessWidget {
  final List<String> header;
  final Word word;
  final Function memorize;

  styles(context) => [
        Theme.of(context).textTheme.headlineMedium,
        Theme.of(context).textTheme.headlineSmall,
      ];
  const WordBoard(
      {super.key,
      required this.word,
      required this.memorize,
      required this.header});

  @override
  Widget build(BuildContext context) {
    final subService = context.watch<SubtitlesService>();
    const langId = 0;
    final examples =
        subService.resolve(term: 'ยก', lang: header[langId], count: 3);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: joinBoardItems(context, buildWordItems(context),
                buildExamples(context, examples))));
  }

  List<Widget> joinBoardItems(context, List<Tuple2<Widget, Widget>> wordItems,
      List<Tuple2<Widget, Widget>> examples) {
    List<Widget> unfold(List<Tuple2<Widget, Widget>> items) => items
        .expand((tuple) => [
              tuple.item1,
              tuple.item2,
              Divider(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
              )
            ])
        .toList();
    final result = unfold(wordItems) +
        [
          Divider(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
          )
        ] +
        unfold(examples);
    result.removeLast();
    return result;
  }

  List<Tuple2<Widget, Widget>> buildWordItems(context) {
    return List.generate(
        header.length,
        (index) => buildWordItem(context, header[index], word[index].phrase,
            styles(context)[index > 0 ? 1 : 0])).toList();
  }

  Tuple2<Widget, Widget> buildWordItem(context, lang, phrase, style) {
    return Tuple2(
        Text(
          lang.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          phrase,
          style: style,
        ));
  }

  List<Tuple2<Widget, Widget>> buildExamples(
      context, Map<String, List<String>> examples) {
    return List.generate(
        examples.values.first.length,
        (index) => buildExampleItem(
            context, index, examples.entries.map((e) => e.value[index])));
  }

  Tuple2<Widget, Widget> buildExampleItem(context, index, phrases) {
    return Tuple2(
        Text(
          'EXAMPLE ${index + 1}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          phrases.map((phrase) => phrase.replaceAll('\n', '')).join('\n'),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary, height: 2),
        ));
  }
}
