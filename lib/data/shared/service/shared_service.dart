import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedService {
  Future<dynamic> getData(String key);
  Future<void> setData(String key, var data);
  Future<void> removeData(String key);
  Future<void> updateData(String key, dynamic data);
}

class SharedServiceImp implements SharedService {
  final _pref = SharedPreferences.getInstance();

  @override
  Future getData(String key) async {
    final sp = await _pref;
    sp.get(key);
  }

  @override
  Future<void> removeData(String key) async {
    final sp = await _pref;
    sp.remove(key);
  }

  @override
  Future<void> setData(String key, data) async {
    final sp = await _pref;
    switch (data.runtimeType) {
      case String:
        await sp.setString(key, data);
        break;
      case double:
        await sp.setDouble(key, data);
        break;
      case int:
        await sp.setInt(key, data);
        break;
      case bool:
        await sp.setBool(key, data);
        break;
      case List<String>:
        await sp.setStringList(key, data);
        break;
      default:
        throw Exception('Incorrect type');
    }
  }

  @override
  Future<void> updateData(String key, data) async {
    final sp = await _pref;
    await sp.remove(key);
    await setData(key, data);
  }
}
