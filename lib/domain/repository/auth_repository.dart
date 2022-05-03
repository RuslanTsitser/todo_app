import '../model/export_model.dart';

abstract class AuthRepository {
  Future<bool> login(String username, String password);

  Future<void> logout();

  Future<List<User>> getUsers();

  Future<void> createTask(int id, String title);

  Future<Todo> readTask(int id);

  Future<void> updateTask({
    required int id,
    String? title,
    required TodoStatus newStatus,
  });

  Future<void> deleteTask(int id);

  Future<void> setPerformer(User performer);

  Future<void> removePerformer();
}
