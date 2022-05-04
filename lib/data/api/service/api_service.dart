import 'package:dio/dio.dart';
import 'package:todo_app/data/api/model/export_model_api.dart';
import 'package:todo_app/data/api/request/export_body.dart';

abstract class _ApiService {
  // Получить users списком
  Future<List<ApiUser>> getUsers(GetUserBody body);
}

class ApiService extends _ApiService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  // Основные настройки для взаимодействия с сетью
  final _dio = Dio(
    BaseOptions(baseUrl: baseUrl),
  );

  @override
  Future<List<ApiUser>> getUsers(GetUserBody body) async {
    try {
      final response = await _dio.get('/users');
      final listData = response.data as List;

      return listData.map((e) => ApiUser.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
