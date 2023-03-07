import 'package:flutter/material.dart';
import 'package:path_in_the_woods/services/location_service.dart';
import 'package:path_in_the_woods/utils/resolve_settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends StatefulWidget {
  const AppPreferences({super.key});

  @override
  State<AppPreferences> createState() => _AppPreferencesState();
}

class _AppPreferencesState extends State<AppPreferences> {
  double? minimumMovement;
  double? minimumInterval;

  Future<List> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    minimumMovement =
        (ResolveSettings.resolve(prefs, LocationService.serviceRadius) as int)
            .toDouble();

    minimumInterval =
        (ResolveSettings.resolve(prefs, LocationService.serviceInterval) as int)
            .toDouble();

    return [
      prefs,
      {LocationService.serviceRadius.item1: minimumMovement,
      LocationService.serviceInterval.item1: minimumInterval}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final SharedPreferences prefs = snapshot.data![0];
            final Map<String, dynamic> settings = snapshot.data![1];

            return SettingsList(sections: [
              SettingsSection(
                title: Text('Location'.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium),
                tiles: [
                  SettingsTile.navigation(
                    title: Text(
                      'Movement Threshold',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    // description: ,
                    leading: Icon(
                      Icons.social_distance,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    trailing: Text('${minimumMovement!.toInt()} M'),
                    value: Column(
                      children: [
                        const Text(
                            'It is the minimum distance between two consecutive location recordings.'),
                        Slider(
                          min: 10.0,
                          max: 100.0,
                          divisions: 9,
                          onChanged: (double value) {
                            prefs.setInt(LocationService.serviceRadius.item1,
                                value.toInt());
                            setState(() {
                              minimumMovement = value;
                            });
                          },
                          value: settings[LocationService.serviceRadius.item1],
                        ),
                      ],
                    ),
                  ),
                  SettingsTile.navigation(
                    title: Text(
                      'Duration Threshold',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    // description: ,
                    leading: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    trailing: Text('${minimumInterval!.toInt()} S'),
                    value: Column(
                      children: [
                        const Text(
                            'It is the minimum time period between two consecutive location recordings.'),
                        Slider(
                          min: 5.0,
                          max: 30.0,
                          divisions: 5,
                          onChanged: (double value) {
                            prefs.setInt(LocationService.serviceInterval.item1,
                                value.toInt());
                            setState(() {
                              minimumInterval = value;
                            });
                          },
                          value: settings[LocationService.serviceInterval.item1],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
