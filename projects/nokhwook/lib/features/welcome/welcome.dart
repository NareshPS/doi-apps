import 'package:flutter/material.dart';
import 'package:nokhwook/components/word_grid.dart';
import 'package:nokhwook/features/engagement/word_reminder.dart';
import 'package:nokhwook/features/stages/word_stage.dart';
import 'package:nokhwook/features/welcome/memorized_subset.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final errors = <String>[];

  @override
  Widget build(BuildContext context) {
    final vocab = context.watch<Vocab>();
    final memorizedSubset = context.watch<MemorizedSubset>();
    final reminderMessage = context.watch<WordReminderMessage?>();
    final errorMessage = context.watch<String?>();

    if (errorMessage != null) errors.add(errorMessage);

    logger.i(
        'Memorized Subset: ${memorizedSubset.subset} Reminder: ${reminderMessage?.wordId}');
    // return Column(
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(4.0)),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: errors
                  .map((e) => Text(
                        e,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                      ))
                  .toList(),
            ),
          ),
        ),
        reminderMessage?.wordId != null
            ? WordStage(
                vocab: vocab,
                wordId: reminderMessage?.wordId,
              )
            : const Text(''),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'You have learnt ${memorizedSubset.subset.length} words!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        if (memorizedSubset.subset.isNotEmpty)
          Center(
            child: WordGrid(
                title: 'Memorized Words',
                vocab: vocab,
                subset: memorizedSubset.subset),
          ),
      ],
    );
  }
}
