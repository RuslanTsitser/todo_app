import 'dart:convert';

import '../../domain/model/export_model.dart';
import '../api/model/export_model_api.dart';
import '../mapper/model_mapper.dart';
import 'service/shared_service.dart';

class SharedUtil {
  final SharedService _sharedService;

  SharedUtil(this._sharedService);

  Future<String> getToken() async {
    const _key = 'token';

    var token = await _sharedService.getData(_key);
    return token;
  }

  Future<void> setToken(String token) async {
    const _key = 'token';

    await _sharedService.setData(_key, token);
  }

  Future<void> deleteToken() async {
    const _key = 'token';

    await _sharedService.removeData(_key);
  }

  Future<void> setTodoList(List<Todo> todoList) async {
    var token = await getToken();
    final _key = '$token todo list';

    final todoListJSON = todoList.map((todo) {
      final todoMap = ModelMapper.todoToMap(todo);
      final todoJSON = ModelMapper.toJson(todoMap);
      return todoJSON;
    }).toList();

    await _sharedService.setListData(_key, todoListJSON);
  }

  Future<List<Todo>> getTodoList() async {
    var token = await getToken();
    final _key = '$token todo list';

    final todoListJSON = await _sharedService.getListData(_key);
    final todoList = todoListJSON.map((todoJSON) {
      final Map<String, dynamic> json = const JsonDecoder().convert(todoJSON);
      final apiTodo = ApiTodo.fromJson(json);
      final task = ModelMapper.todoFromJSON(apiTodo);
      return task;
    }).toList();

    return todoList;
  }

  Future<void> clearTodoList() async {
    var token = await getToken();
    final _key = '$token todo list';
    await _sharedService.removeData(_key);
  }

  Future<List<Todo>> addTodo({
    required String id,
    required String title,
  }) async {
    final todoList = await getTodoList();

    final newTodo = Todo(
      id: id,
      title: title,
    );
    todoList.add(newTodo);
    await clearTodoList();
    await setTodoList(todoList);
    return todoList;
  }

  Future<Todo> getTodo(String id) async {
    final todoList = await getTodoList();

    final targetTodo = todoList.firstWhere((todo) => todo.id == id);
    return targetTodo;
  }

  Future<List<Todo>> removeTodo(String id) async {
    final todoList = await getTodoList();
    todoList.removeWhere((element) => element.id == id);
    await clearTodoList();
    await setTodoList(todoList);
    return todoList;
  }

  Future<List<Todo>> updateTodo({
    required String id,
    String? title,
    TodoStatus? status,
    User? performer,
  }) async {
    final todoList = await getTodoList();

    final targetTodo = todoList.firstWhere((todo) {
      return todo.id == id;
    });
    final index = todoList.indexWhere((todo) {
      return todo.id == id;
    });

    final newTodo = Todo(
      id: targetTodo.id,
      title: title ?? targetTodo.title,
    );

    newTodo.updateStatus(status ?? targetTodo.status);
    newTodo.updatePerformer(performer ?? targetTodo.performer);

    todoList.removeWhere((element) => element.id == id);
    todoList.insert(index, newTodo);

    await clearTodoList();
    await setTodoList(todoList);

    return todoList;
  }
}
