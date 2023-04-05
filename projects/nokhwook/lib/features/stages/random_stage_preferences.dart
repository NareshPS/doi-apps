import 'package:flutter/material.dart';
import 'package:nokhwook/features/preferences/resolve_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class RandomStagePreferences with ChangeNotifier {
  static const randomSampleSize = Tuple2('randomSampleSize', 10);
  static const randomPlaySpeed = Tuple2('randomPlaySpeed', 1.0);

  final SharedPreferences prefs;

  RandomStagePreferences(this.prefs);

  int get sampleSize => ResolvePreferences.resolve(prefs, randomSampleSize);
  double get playSpeed => ResolvePreferences.resolve<double>(prefs, randomPlaySpeed);

  set sampleSize(size) =>
      updateAndNotify(() => prefs.setInt(randomSampleSize.item1, size));
  
  set playSpeed(speed) =>
      updateAndNotify(() => prefs.setDouble(randomPlaySpeed.item1, speed));

  updateAndNotify(callback) async {
    await callback();
    notifyListeners();
  }
}
