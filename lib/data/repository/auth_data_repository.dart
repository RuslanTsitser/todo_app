import 'dart:convert';

import '../../domain/model/export_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../api/api_util.dart';
import '../shared/shared_util.dart';

class AuthDataRepository extends AuthRepository {
  final ApiUtil _apiUtil;
  final SharedUtil _sharedUtil;

  AuthDataRepository(
    this._apiUtil,
    this._sharedUtil,
  );

  @override
  Future<bool> login(String username, String password) async {
    const rightUsername = 'username';
    const rightPassword = 'password';

    if (username == rightUsername && password == rightPassword) {
      var bytes = utf8.encode(username + ':' + password);
      var token = base64.encode(bytes);
      _sharedUtil.setToken(token);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> loginWithToken() async {
    try {
      var token = await _sharedUtil.getToken();
      // ignore: avoid_print
      print(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _sharedUtil.deleteToken();
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      return await _apiUtil.getUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Todo>> getTodoList() async {
    try {
      return await _sharedUtil.getTodoList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearTodoList() async {
    try {
      await _sharedUtil.clearTodoList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Todo>> createTodo(String id, String title) async {
    try {
      return await _sharedUtil.addTodo(id: id, title: title);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Todo> readTodo(String id) async {
    try {
      return await _sharedUtil.getTodo(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Todo>> updateTodo({
    required String id,
    String? newTitle,
    TodoStatus? newStatus,
    User? newPerformer,
  }) async {
    try {
      return await _sharedUtil.updateTodo(
        id: id,
        title: newTitle,
        status: newStatus,
        performer: newPerformer,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Todo>> deleteTodo(String id) async {
    try {
      return await _sharedUtil.removeTodo(id);
    } catch (e) {
      rethrow;
    }
  }
}
