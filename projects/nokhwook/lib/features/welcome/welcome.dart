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

    logger.i(
        'Memorized Subset: ${memorizedSubset.subset} Reminder: ${reminderMessage?.wordId}');
    return ListView(
      children: [
        errors.isNotEmpty
            ? Padding(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                            ))
                        .toList(),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        reminderMessage?.wordId != null
            ? WordStage(
                vocab: vocab,
                wordId: reminderMessage?.wordId,
              )
            : const SizedBox.shrink(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: memorizedSubset.subset.isNotEmpty
                    ? Text(
                        'You have saved ${memorizedSubset.subset.length} ${memorizedSubset.subset.length == 1 ? 'word' : 'words'} to practice.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    : Text(
                        'Click the shuffle tab to take a look at some words. The saved words will appear here!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
              ),
            ),
          ),
        ),
        if (memorizedSubset.subset.isNotEmpty)
          Center(
            child: WordGrid(
                title: 'Saved Words',
                vocab: vocab,
                subset: memorizedSubset.subset),
          ),
      ],
    );
  }
}
