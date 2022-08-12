import 'package:injectable/injectable.dart';

import '../model/export_model.dart';

@injectable
abstract class AuthRepository {
  // Залогиниться с логином и паролем
  Future<bool> login(String username, String password);

  // Залогиниться с токеном
  Future<bool> loginWithToken();

  // Покинуть учетную запись
  Future<void> logout();

  // Получить список подчиненных
  Future<List<User>> getUsers();

  // Получить список созданных todo
  Future<List<Todo>> getTodoList();

  // очистить список todo
  Future<void> clearTodoList();

  // CRUD
  Future<List<Todo>> createTodo(String id, String title);

  Future<Todo> readTodo(String id);

  Future<List<Todo>> updateTodo({
    required String id,
    String? newTitle,
    TodoStatus? newStatus,
    User? newPerformer,
  });

  Future<List<Todo>> deleteTodo(String id);
}
