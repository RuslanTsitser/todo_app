import 'dart:convert';

import 'package:todo_app/data/api/model/api_todo.dart';

import '../../domain/model/export_model.dart';
import '../api/model/export_model_api.dart';

class ModelMapper {
  static String toJson(Map<String, dynamic> map) {
    final String json = const JsonEncoder().convert(map).toString();
    return json;
  }

  static User userFromJSON(ApiUser apiUser) {
    return User(id: apiUser.id, name: apiUser.name);
  }

  static Map<String, dynamic> userToMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
    };
  }

  static Todo todoFromJSON(ApiTodo apiTodo) {
    final task = Todo(
      id: apiTodo.id,
      title: apiTodo.title,
    );

    late TodoStatus _status;
    switch (apiTodo.status) {
      case 'waiting':
        _status = TodoStatus.waiting;
        break;
      case 'inProgress':
        _status = TodoStatus.inProgress;
        break;
      case 'completed':
        _status = TodoStatus.completed;
        break;
      default:
        _status = TodoStatus.waiting;
    }
    task.updateStatus(_status);

    late User? performer;
    if (apiTodo.performer != null) {
      performer = userFromJSON(apiTodo.performer!);
      task.updatePerformer(performer);
    }

    return task;
  }

  static Map<String, dynamic> todoToMap(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'status': todo.status.name,
      'performer': todo.performer,
    };
  }
}
