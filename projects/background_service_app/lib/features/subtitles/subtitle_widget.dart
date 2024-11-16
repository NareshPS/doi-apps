import 'package:background_service_app/features/subtitles/bilingual_subtitles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class SubtitleWidget extends StatefulWidget {
  const SubtitleWidget({super.key});

  @override
  State<SubtitleWidget> createState() => _SubtitleWidgetState();
}

class _SubtitleWidgetState extends State<SubtitleWidget> {
  final searchController = TextEditingController();
  final examples = <String, List<int>>{};
  late final BilingualSubtitles subtitles;
  bool loaded = false;
  String term = '';

  load() async {
    subtitles = BilingualSubtitles(sources: {
      'Thai': 'assets/subtitles/captain.america.the.first.avenger.2011.th.srt',
      'English':
          'assets/subtitles/captain.america.the.first.avenger.2011.en.srt',
    });
    await subtitles.load();
    loaded = true;
    // final matches = subtitles.searchMany(term, 'Thai', count: 3);
    // setState(() {
    //   examples.addAll(matches);
    // });
  }

  @override
  void initState() {
    super.initState();

    load();
  }

  void search() {
    term = searchController.value.text;
    // term = 'หนุ่ม';
    final matches = subtitles.alignedSearch(term, 'Thai', count: 2);

    setState(() {
      examples.clear();
      examples.addAll(matches);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (loaded) search();

    return Column(children: <Widget>[
      Text('Examples for search term: $term'),
      Row(children: [
        Expanded(child: TextField(controller: searchController)),
        TextButton(onPressed: search, child: const Text('Search'))
      ]),
      if (examples.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Table(
            border: TableBorder.symmetric(
                outside: BorderSide(
                    width: 1.0, color: Theme.of(context).primaryColor)),
            children: [
                  TableRow(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      children: const [
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Examples',
                          ),
                        ))
                      ])
                  // children: subtitles.languageSubtitles.entries
                  //     .map((e) => Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Center(child: Text(e.key.toUpperCase())),
                  //         ))
                  //     .toList())
                ] +
                tableContents(context, term),
          ),
        )
    ]);
    // return Column(
    //     children: <Widget>[
    //           Text('Examples for search term: $term'),
    //           Row(children: [
    //             Expanded(child: TextField(controller: searchController)),
    //             TextButton(onPressed: search, child: Text('Search'))
    //           ]),
    //         ] +
    //         (examples.isNotEmpty
    //             ? <Widget>[
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                     children: subtitles.languageSubtitles.entries
    //                         .map((e) => Text(e.key.toUpperCase()))
    //                         .toList(),
    //                   )
    //                 ] +
    //                 []
    //                 // examples
    //                 //     .map((subtitleId) => Padding(
    //                 //           padding: const EdgeInsets.all(8.0),
    //                 //           child: Row(
    //                 //               crossAxisAlignment: CrossAxisAlignment.start,
    //                 //               children: [],
    //                 //               // children: subtitles.languageSubtitles.entries
    //                 //               //     .map(
    //                 //               //       (e) => Expanded(
    //                 //               //         flex: 1,
    //                 //               //         child: format(
    //                 //               //             e.value.subtitles[subtitleId!],
    //                 //               //             term),
    //                 //               //         // child: Text.rich(textSpan),
    //                 //               //         // child: RichText(
    //                 //               //         //     text: TextSpan(
    //                 //               //         //         text:
    //                 //               //         //             '${e.value.subtitles[subtitleId!].startTime} ${e.value.subtitles[subtitleId!].endTime}',
    //                 //               //         //         children: [TextSpan()]))
    //                 //               //         // child: Text(
    //                 //               //         //   '${e.value.subtitles[subtitleId!].startTime} ${e.value.subtitles[subtitleId!].endTime} ${e.value.subtitles[subtitleId!].text}',
    //                 //               //         //   softWrap: true,
    //                 //               //         // ),
    //                 //               //       ),
    //                 //               //     )
    //                 //               //     .toList()
    //                 //                   ),
    //                 //         ))
    //                 //     .toList()
    //             : []));
  }

  // tableContents(context) {
  //   int numRows = examples.values.first.length;

  //   return List<TableRow>.generate(numRows, (rowId) {
  //     return TableRow(
  //         children: subtitles.languageSubtitles.entries
  //             .map((e) => Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child:
  //                       Text(e.value.subtitles[examples[e.key]![rowId]].text),
  //                 ))
  //             .toList());
  //   });
  // }
  tableContents(context, term) {
    tableItem(itemId) {
      return subtitles.languageSubtitles.entries
          .map((e) =>
              format(e.value.subtitles[examples[e.key]![itemId]].text, term))
          .toList();
    }

    int numItems = examples.values.first.length;
    return List.generate(numItems, tableItem)
        .expand((element) => [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: element),
              )
            ])
        .map((e) => TableRow(children: [e]))
        .toList();
  }

  Widget format(text, term) {
    final splits = text.split(term);
    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: TextStyle(color: Colors.green), children: [
            TextSpan(text: splits[0]),
            if (splits.length > 1)
              TextSpan(
                  text: term,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (splits.length > 1) TextSpan(text: splits[1])
          ])),
    );
  }
}
