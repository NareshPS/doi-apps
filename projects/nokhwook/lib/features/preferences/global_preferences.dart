import 'package:flutter/foundation.dart';
import 'package:nokhwook/features/preferences/resolve_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class GlobalPreferences extends ChangeNotifier {
  static const defaultTargetLanguage = Tuple2('targetLanguage', 'th');

  final SharedPreferences prefs;

  GlobalPreferences(this.prefs);

  String get targetLanguage =>
      ResolvePreferences.resolve<String>(prefs, defaultTargetLanguage);

  set targetLanguage(String value) => updateAndNotify(
      () => prefs.setString(defaultTargetLanguage.item1, value));

  void updateAndNotify(callback) async {
    await callback();
    notifyListeners();
  }
}
