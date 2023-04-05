import 'package:flutter/material.dart';
import 'package:nokhwook/features/preferences/resolve_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class MemorizedSubset with ChangeNotifier {
  static const memorizedSubset = Tuple2('memorizedSubset', <String>[]);

  final SharedPreferences prefs;

  MemorizedSubset(this.prefs);

  List<int> get subset =>
      (ResolvePreferences.resolveList(prefs, memorizedSubset))
          .toSet()
          .map(int.parse)
          .toList();

  append(index) => updateAndNotify(() {
        final items = subset..add(index);
        return prefs.setStringList(
            memorizedSubset.item1, items.map((v) => v.toString()).toList());
      });

  updateAndNotify(callback) async {
    await callback();
    notifyListeners();
  }
}
