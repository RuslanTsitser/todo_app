import 'package:todo_app/data/api/service/api_service.dart';
import 'package:todo_app/data/mapper/model_mapper.dart';

import '../../domain/model/export_model.dart';
import 'request/export_body.dart';

class ApiUtil {
  final ApiService apiService;

  ApiUtil(this.apiService);

  Future<List<User>> getUsers() async {
    try {
      final body = GetUserBody();
      final result = await apiService.getUsers(body);

      return result
          .map((apiUser) => ModelMapper.userFromJSON(apiUser))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
