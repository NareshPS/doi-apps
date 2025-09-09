import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:nokhwook/features/preferences/global_preferences.dart';
import 'package:nokhwook/features/stages/random_stage_preferences.dart';
import 'package:nokhwook/features/welcome/memorized_subset.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/services/constants_service.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class AppPreferences extends StatefulWidget {
  const AppPreferences({super.key});

  @override
  State<AppPreferences> createState() => _AppPreferencesState();
}

class _AppPreferencesState extends State<AppPreferences> {
  // Related to global preferences
  late GlobalPreferences globalPreferences;
  late String targetLanguage;

  // Related to random stage preferences
  late RandomStagePreferences randomStagePreferences;
  late double randomSampleSize;
  late double randomPlaySpeed;

  // Related to home page preferences
  static const memorizedSubsetMin = 20.0;
  static const memorizedSubsetMax = 40.0;

  late MemorizedSubset memorizedSubsetPreferences;
  late int memorizedSubsetSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize fields for global preferences
    globalPreferences = context.watch<GlobalPreferences>();
    targetLanguage = globalPreferences.targetLanguage;

    // Initialize fields for random stage
    randomStagePreferences = context.watch<RandomStagePreferences>();
    randomSampleSize = randomStagePreferences.sampleSize.toDouble();
    randomPlaySpeed = randomStagePreferences.playSpeed;

    // Initialize fields for home page
    memorizedSubsetPreferences = context.watch<MemorizedSubset>();
    memorizedSubsetSize = memorizedSubsetPreferences.subsetSize;

    // It could happen that a subsequent app update changes the min and max values
    // such that they become incomparible with the saved value in shared preferences.
    // In such a case, we need to reset the value to the max.
    if (memorizedSubsetSize < memorizedSubsetMin ||
        memorizedSubsetSize > memorizedSubsetMax) {
      memorizedSubsetSize = memorizedSubsetMax.toInt();
      memorizedSubsetPreferences.subsetSize = memorizedSubsetSize;
    }

    logger.i('Memorized Subset Size: $memorizedSubsetSize');
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Global'.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall),
          tiles: [
            SettingsTile.navigation(
              title: Text(
                'Target Language',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
              ),
              trailing: Text(targetLanguage.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              value: Column(
                children: [
                  const Text(
                      'Select one of Thai (TH) or Vietnamese (VT) languages to learn.'),
                  FlutterToggleTab(
                    dataTabs: ConstantsService.targetLanguages
                        .map((lang) => DataTab(title: lang))
                        .toList(),
                    selectedLabelIndex: (index) => setState(() {
                      targetLanguage = ConstantsService.targetLanguages[index];
                    }),
                    selectedIndex: ConstantsService.targetLanguages
                        .indexOf(targetLanguage),
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsSection(
            title: Text('Home'.toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall),
            tiles: [
              SettingsTile.navigation(
                title: Text(
                  'Saved Memory Size',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                leading: Icon(
                  Icons.save_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: Text('$memorizedSubsetSize',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
                value: Column(
                  children: [
                    const Text(
                        'It indicates the maximum number of words that can be saved. \n\nIf you reduce the memory size to lower than the number of currently saved words, some words will be lost.'),
                    Slider(
                      min: memorizedSubsetMin,
                      max: memorizedSubsetMax,
                      divisions: 9,
                      onChangeEnd: (_) => memorizedSubsetPreferences
                          .subsetSize = memorizedSubsetSize,
                      value: memorizedSubsetSize.toDouble(),
                      onChanged: (double value) =>
                          setState(() => memorizedSubsetSize = value.toInt()),
                    ),
                  ],
                ),
              ),
            ]),
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
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
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
              ),
            ]),
      ],
    );
  }
}
