import 'dart:convert';

import '../../domain/model/export_model.dart';
import '../api/model/export_model_api.dart';

class ModelMapper {
  // Общая команда для преобразования в json
  static String toJson(Map<String, dynamic> map) {
    final String json = const JsonEncoder().convert(map).toString();
    return json;
  }

  // получение user из json
  static User userFromJSON(ApiUser apiUser) {
    return User(id: apiUser.id, name: apiUser.name);
  }

  // преобразование user в Map
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
      case 'Ожидание':
        _status = TodoStatus.waiting;
        break;
      case 'В работе':
        _status = TodoStatus.inProgress;
        break;
      case 'Выполнено':
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
    Map<String, dynamic> map = {
      'id': todo.id,
      'title': todo.title,
      'status': todo.status.name,
    };
    if (todo.performer != null) {
      map['performer'] = userToMap(todo.performer!);
    }
    return map;
  }
}
