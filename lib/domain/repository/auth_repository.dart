import '../model/export_model.dart';

abstract class AuthRepository {
  Future<bool> login(String username, String password);

  Future<bool> loginWithToken();

  Future<void> logout();

  Future<List<User>> getUsers();

  Future<List<Todo>> getTodoList();

  Future<void> clearTodoList();

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
