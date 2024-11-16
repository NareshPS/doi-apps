import 'package:flutter/material.dart';

class WordExamples extends StatelessWidget {
  final List<String> languages;
  final Map<String, List<String>> examples;
  final String keyTerm;
  const WordExamples(
      {super.key,
      required this.languages,
      required this.examples,
      required this.keyTerm});

  @override
  Widget build(BuildContext context) {
    return Table(
        children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Examples'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              ])
            ] +
            List.generate(
                    examples.values.first.length,
                    (itemId) => languages
                        .map((lang) =>
                            format(context, examples[lang]![itemId], keyTerm))
                        .toList()
                      ..add(const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      )))
                .map((e) => TableRow(children: [Column(children: e)]))
                .toList());
  }

  // tableItem(context, itemId, term) {
  //   return Tuple2(
  //       itemId,
  //       languages
  //           .map((lang) => format(context, examples[lang]![itemId], term))
  //           .toList());
  // }

  // tableContents(context, Map<String, List<String>> examples, term) {
  //   tableItem(itemId) {
  //     return Tuple2(
  //         itemId,
  //         languages
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

  Widget format(context, text, term) {
    final splits = text.split(term);
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            children: [
              TextSpan(text: splits[0]),
              if (splits.length > 1)
                TextSpan(
                    text: term,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize! +
                              4,
                        )),
              if (splits.length > 1) TextSpan(text: splits[1])
            ]));
  }
}
