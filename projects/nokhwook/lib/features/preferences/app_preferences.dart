import 'package:flutter/material.dart';
import 'package:nokhwook/features/stages/random_stage_preferences.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class AppPreferences extends StatefulWidget {
  const AppPreferences({super.key});

  @override
  State<AppPreferences> createState() => _AppPreferencesState();
}

class _AppPreferencesState extends State<AppPreferences> {
  late RandomStagePreferences randomStagePreferences;
  late double randomSampleSize;
  late double randomPlaySpeed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    randomStagePreferences = context.watch<RandomStagePreferences>();
    randomSampleSize = randomStagePreferences.sampleSize.toDouble();
    randomPlaySpeed = randomStagePreferences.playSpeed;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(sections: [
      SettingsSection(
          title: Text('Random Cards'.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall),
          tiles: [
            SettingsTile.navigation(
              title: Text(
                'Count',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.sync_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              trailing: Text('${randomSampleSize.toInt()}',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              value: Column(
                children: [
                  const Text(
                      'It indicates the maximum number of cards in the deck.'),
                  Slider(
                    min: 2.0,
                    max: 20.0,
                    divisions: 9,
                    onChangeEnd: (_) => randomStagePreferences.sampleSize =
                        randomSampleSize.toInt(),
                    value: randomSampleSize,
                    onChanged: (double value) =>
                        setState(() => randomSampleSize = value),
                  ),
                ],
              ),
            ),
            SettingsTile.navigation(
              title: Text(
                'Play Duration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.speed,
                color: Theme.of(context).colorScheme.primary,
              ),
              trailing: Text(
                '${(randomPlaySpeed * randomSampleSize).toStringAsFixed(1)}s',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              value: Column(
                children: [
                  const Text(
                    'It indicates the total play duration of random cards in seconds.',
                  ),
                  Slider(
                    min: .5,
                    max: 5,
                    divisions: 9,
                    onChangeEnd: (_) =>
                        randomStagePreferences.playSpeed = randomPlaySpeed,
                    value: randomPlaySpeed,
                    onChanged: (double value) =>
                        setState(() => randomPlaySpeed = value),
                  ),
                ],
              ),
            )
          ])
    ]);
  }
}
