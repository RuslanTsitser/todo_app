import 'package:shared_preferences/shared_preferences.dart';

// Данные сохранять будем как текст
abstract class SharedService {
  // получить данные с кэша как список данных
  Future<List<String>> getListData(String key);
  // получить данные из кэша как отельную сущность
  Future<String> getData(String key);
  // сохранить в кэше список данных
  Future<void> setListData(String key, List<String> data);
  // сохранить объект
  Future<void> setData(String key, String data);
  // удалить объект
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
