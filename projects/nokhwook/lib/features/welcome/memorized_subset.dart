import 'package:flutter/material.dart';
import 'package:nokhwook/features/preferences/global_preferences.dart';
import 'package:nokhwook/features/preferences/resolve_preferences.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/utils/list_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class MemorizedSubset with ChangeNotifier {
  static const memorizedSubsetLegacy = Tuple2('memorizedSubset', <String>[]);
  static const memorizedSubsetSize = Tuple2('memorizedSubsetSize', 20);

  final SharedPreferences prefs;
  final GlobalPreferences globalPreferences;

  MemorizedSubset(this.prefs, this.globalPreferences) {
    // **Backward Compatibility**
    // Migrate legacy data if exists
    if (prefs.containsKey(memorizedSubsetLegacy.item1)) {
      // Get the legacy data
      final legacy = prefs.getStringList(memorizedSubsetLegacy.item1) ?? [];

      // Migrate the data to the new key
      prefs.setStringList(memorizedSubsetDefault.item1,
          legacy.toSet().toList().takeLast(subsetSize));

      // Remove the old key
      prefs.remove(memorizedSubsetLegacy.item1);

      logger.i(
          'Migrated legacy memorized subset data: $legacy to ${memorizedSubsetDefault.item1}');
    }
  }

  // Get and update the memorized subset
  List<int> get subset =>
      (ResolvePreferences.resolveList(prefs, memorizedSubsetDefault))
          .toSet()
          .map(int.parse)
          .toList()
          .takeLast(subsetSize);

  void append(int index) => updateAndNotify(() {
        final items = subset..add(index);
        return prefs.setStringList(memorizedSubsetDefault.item1,
            items.map((v) => v.toString()).toList());
      });

  // Get and update the maximum size of memorized subset.
  int get subsetSize =>
      ResolvePreferences.resolve<int>(prefs, memorizedSubsetSize);

  set subsetSize(int size) =>
      updateAndNotify(() => prefs.setInt(memorizedSubsetSize.item1, size));

  void updateAndNotify(callback) async {
    await callback();
    notifyListeners();
  }

  Tuple2 get memorizedSubsetDefault =>
      Tuple2('memorizedSubset.${globalPreferences.targetLanguage}', <String>[]);
}
