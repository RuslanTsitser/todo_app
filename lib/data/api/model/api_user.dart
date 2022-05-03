import 'package:todo_app/data/api/model/model_api.dart';

class ApiUser extends ModelApi {
  final int id;
  final String name;

  ApiUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '',
        super.fromJson(json);
}
