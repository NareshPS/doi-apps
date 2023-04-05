import 'package:background_service_app/features/subtitles/bilingual_subtitles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class SubtitleWidget extends StatefulWidget {
  final String path;

  const SubtitleWidget({super.key, required this.path});

  @override
  State<SubtitleWidget> createState() => _SubtitleWidgetState();
}

class _SubtitleWidgetState extends State<SubtitleWidget> {
  final examples = [];
  late final BilingualSubtitles subtitles;
  late String term;

  load() async {
    subtitles = BilingualSubtitles(sources: {
      'Thai': 'assets/subtitles/captain.america.the.first.avenger.2011.th.srt',
      'English':
          'assets/subtitles/captain.america.the.first.avenger.2011.en.srt',
    });
    await subtitles.load();
    final matches = subtitles.searchMany(term, 'Thai', count: 3);
    setState(() {
      examples.addAll(matches);
    });
    // final data = await rootBundle.loadString(widget.path);

    // final controller = SubtitleController(subtitlesContent: data);
    // final repository = SubtitleDataRepository(subtitleController: controller);

    // Subtitles subtitles = repository.getSubtitlesData(data, SubtitleType.srt);
    // print('Total fragments: ${subtitles.subtitles.length}');
    // print('Random Sample: ${subtitles.subtitles[100]}');
  }
  // load() async {
  //   final regExp = RegExp(
  //     r'((\d{2}):(\d{2}):(\d{2})\,(\d+)) +--> +((\d{2}):(\d{2}):(\d{2})\,(\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
  //     caseSensitive: false,
  //     multiLine: true,
  //   );
  //   final data = await rootBundle.loadString(widget.path);

  //   final matches = regExp.allMatches(data).toList();
  //   final subtitleList = <Subtitle>[];

  //   for (final regExpMatch in matches) {
  //     final startTimeHours = int.parse(regExpMatch.group(2)!);
  //     final startTimeMinutes = int.parse(regExpMatch.group(3)!);
  //     final startTimeSeconds = int.parse(regExpMatch.group(4)!);
  //     final startTimeMilliseconds = int.parse(regExpMatch.group(5)!);

  //     final endTimeHours = int.parse(regExpMatch.group(7)!);
  //     final endTimeMinutes = int.parse(regExpMatch.group(8)!);
  //     final endTimeSeconds = int.parse(regExpMatch.group(9)!);
  //     final endTimeMilliseconds = int.parse(regExpMatch.group(10)!);
  //     print(startTimeHours);
  //     // final text = removeAllHtmlTags(regExpMatch.group(11)!);

  //     final startTime = Duration(
  //       hours: startTimeHours,
  //       minutes: startTimeMinutes,
  //       seconds: startTimeSeconds,
  //       milliseconds: startTimeMilliseconds,
  //     );
  //     final endTime = Duration(
  //       hours: endTimeHours,
  //       minutes: endTimeMinutes,
  //       seconds: endTimeSeconds,
  //       milliseconds: endTimeMilliseconds,
  //     );

  //     // subtitleList.add(
  //     //   Subtitle(startTime: startTime, endTime: endTime, text: text.trim()),
  //     // );
  //   }

  //   // return Subtitles(subtitles: subtitleList);
  // }

  @override
  void initState() {
    super.initState();
    term = 'ยก';

    load();
  }

  @override
  Widget build(BuildContext context) {
    if (examples.isNotEmpty) {
      return Column(
          children: <Widget>[
                Text('Examples for search term: $term'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: subtitles.languageSubtitles.entries
                      .map((e) => Text(e.key.toUpperCase()))
                      .toList(),
                )
              ] +
              examples
                  .map((subtitleId) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subtitles.languageSubtitles.entries
                                .map(
                                  (e) => Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.value.subtitles[subtitleId!].text,
                                      softWrap: true,
                                    ),
                                  ),
                                )
                                .toList()),
                      ))
                  .toList());
    } else {
      return Text('No examples available search term: $term');
    }
  }
}
