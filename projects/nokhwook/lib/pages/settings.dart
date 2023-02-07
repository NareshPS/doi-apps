import 'package:flutter/material.dart';
import 'package:nokhwook/pages/side_bar.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/utils/next_word.dart';
import 'package:nokhwook/utils/word.dart';

class Settings extends StatefulWidget {
  final NotificationService notificationService;
  final List<Word<WordItem>> words;

  const Settings({
    super.key,
    required this.notificationService,
    required this.words,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final randomNext = RandomNext();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Let\'s practice'),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      drawer: SideBar(words: widget.words),
      body: Column(
        children: [
          Switch(value: false, onChanged: (value) {
            if (value) {
              final wordId = randomNext.get(widget.words);
              widget.notificationService.scheduleWordReminders(wordId, widget.words[wordId]);
            } else {
              widget.notificationService.cancelWordReminders();
            }

          })
        ],
      ),
    );
  }
}