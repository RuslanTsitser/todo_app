import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedService {
  Future<List<String>> getListData(String key);
  Future<String> getData(String key);
  Future<void> setListData(String key, List<String> data);
  Future<void> setData(String key, String data);
  Future<void> removeData(String key);
}

class SharedServiceImp implements SharedService {
  final _pref = SharedPreferences.getInstance();

  @override
  Future<List<String>> getListData(String key) async {
    final sp = await _pref;
    final listData = sp.getStringList(key);
    if (listData != null) {
      return listData;
    } else {
      return [];
    }
  }

  @override
  Future<String> getData(String key) async {
    final sp = await _pref;
    final data = sp.getString(key);
    if (data != null) {
      return data;
    } else {
      throw '';
    }
  }

  @override
  Future<void> removeData(String key) async {
    final sp = await _pref;
    sp.remove(key);
  }

  @override
  Future<void> setListData(String key, List<String> data) async {
    final sp = await _pref;
    sp.setStringList(key, data);
  }

  @override
  Future<void> setData(String key, String data) async {
    final sp = await _pref;
    sp.setString(key, data);
  }
}
