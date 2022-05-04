import 'package:todo_app/data/api/model/export_model_api.dart';
import 'package:todo_app/data/api/model/model_api.dart';

class ApiTodo extends ModelApi {
  final String id;
  final String title;
  final String status;
  final ApiUser? performer;

  ApiTodo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        status = json['status'],
        performer = (json['performer'] != null)
            ? ApiUser.fromJson(json['performer'])
            : null,
        super.fromJson(json);
}
