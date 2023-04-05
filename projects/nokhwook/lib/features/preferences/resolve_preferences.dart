import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class ResolvePreferences {
  static resolve<T>(SharedPreferences prefs, Tuple2 setting, {override}) {
    return (override ?? prefs.get(setting.item1) ?? setting.item2) as T;
  }

  static List<String> resolveList(SharedPreferences prefs, Tuple2 setting, {override}) {
    return override ?? prefs.getStringList(setting.item1) ?? setting.item2;
  }
}