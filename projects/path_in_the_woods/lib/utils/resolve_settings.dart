import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class ResolveSettings {
  static resolve(SharedPreferences prefs, Tuple2 setting, {override}) {
    return override ?? prefs.get(setting.item1) ?? setting.item2;
  }
}