import 'package:flutter/material.dart';
import 'package:nokhwook/features/preferences/resolve_preferences.dart';
import 'package:nokhwook/utils/list_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class MemorizedSubset with ChangeNotifier {
  static const memorizedSubset = Tuple2('memorizedSubset', <String>[]);
  static const memorizedSubsetSize = Tuple2('memorizedSubsetSize', 20);

  final SharedPreferences prefs;

  MemorizedSubset(this.prefs);

  // Get and update the memorized subset
  List<int> get subset =>
      (ResolvePreferences.resolveList(prefs, memorizedSubset))
          .toSet()
          .map(int.parse)
          .toList()
          .takeLast(subsetSize);

  append(index) => updateAndNotify(() {
        final items = subset..add(index);
        return prefs.setStringList(
            memorizedSubset.item1, items.map((v) => v.toString()).toList());
      });

  // Get and update the maximum size of memorized subset.
  int get subsetSize =>
      ResolvePreferences.resolve<int>(prefs, memorizedSubsetSize);

  set subsetSize(size) =>
      updateAndNotify(() => prefs.setInt(memorizedSubsetSize.item1, size));

  updateAndNotify(callback) async {
    await callback();
    notifyListeners();
  }
}
