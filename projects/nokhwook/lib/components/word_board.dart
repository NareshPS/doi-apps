import 'package:flutter/material.dart';
import 'package:nokhwook/components/separated_column.dart';
import 'package:nokhwook/components/word_board_items.dart';
import 'package:nokhwook/components/word_examples.dart';
import 'package:nokhwook/models/word.dart';
import 'package:nokhwook/services/subtitles_service.dart';
import 'package:provider/provider.dart';

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
    const primaryLangId = 0;
    final searchTerm = word.items[primaryLangId].phrase;
    // const searchTerm = 'จาน';
    // const searchTerm = 'กัน';
    final examples = subService.resolve(
        term: searchTerm, lang: header[primaryLangId], count: 3);

    return SeparatedColumn(
      cushion: SeparatedColumnCushion.none,
      separator: (context) => Divider(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
      ),
      children: List<Widget>.generate(
              header.length,
              (langId) => HeadlineItem(
                    title: header[langId],
                    text: word.items[langId].phrase,
                    type: primaryLangId == langId
                        ? HeadlineItemType.medium
                        : HeadlineItemType.small,
                  )).toList() +
          (examples.values.first.isNotEmpty
              ? [
                  Divider(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0),
                  ),
                  WordExamples(
                    languages: header,
                    examples: examples,
                    keyTerm: searchTerm,
                  )
                ]
              : []),
    );
  }

  // List<Widget> unfold(context, List<Tuple2<Widget, Widget>> items) => items
  //     .expand((tuple) => [
  //           tuple.item1,
  //           tuple.item2,
  //           Divider(
  //             color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
  //           )
  //         ])
  //     .toList();

  // List<Tuple2<Widget, Widget>> buildWordItems(context) {
  //   return List.generate(
  //       header.length,
  //       (index) => buildWordItem(context, header[index], word[index].phrase,
  //           styles(context)[index > 0 ? 1 : 0])).toList();
  // }

  // Tuple2<Widget, Widget> buildWordItem(context, lang, phrase, style) {
  //   return Tuple2(
  //       Text(
  //         lang.toUpperCase(),
  //         style: Theme.of(context).textTheme.labelMedium,
  //       ),
  //       Text(
  //         phrase,
  //         style: style,
  //       ));
  // }

  // buildExamples(context, examples, term) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: Table(
  //       children: [
  //             TableRow(children: [
  //               Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                   child: Text(
  //                     'Examples'.toUpperCase(),
  //                     style: Theme.of(context).textTheme.labelMedium,
  //                   ),
  //                 ),
  //               )
  //             ])
  //           ] +
  //           tableContents(context, examples, term),
  //     ),
  //   );
  // }

  // tableContents(context, Map<String, List<String>> examples, term) {
  //   tableItem(itemId) {
  //     return Tuple2(
  //         itemId,
  //         header
  //             .map((lang) => format(context, examples[lang]![itemId], term))
  //             .toList());
  //   }

  //   int numItems = examples.values.first.length;
  //   return List.generate(numItems, tableItem)
  //       .expand((element) => [
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0),
  //               child: Column(children: element.item2),
  //             )
  //           ])
  //       .map((e) => TableRow(children: [e]))
  //       .toList();
  // }

  // Widget format(context, text, term) {
  //   final splits = text.split(term);
  //   return RichText(
  //       textAlign: TextAlign.center,
  //       text: TextSpan(
  //           style: Theme.of(context)
  //               .textTheme
  //               .bodyMedium!
  //               .copyWith(color: Theme.of(context).colorScheme.secondary),
  //           children: [
  //             TextSpan(text: splits[0]),
  //             if (splits.length > 1)
  //               TextSpan(
  //                   text: term,
  //                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
  //                         color: Theme.of(context).colorScheme.secondary,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium!
  //                                 .fontSize! +
  //                             4,
  //                       )),
  //             if (splits.length > 1) TextSpan(text: splits[1])
  //           ]));
  // }
}
