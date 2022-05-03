import '../../domain/model/export_model.dart';
import '../api/model/export_model_api.dart';
import '../mapper/model_mapper.dart';
import 'service/shared_service.dart';

class SharedUtil {
  final _sharedService = SharedServiceImp();

  Future<void> setTask(int id, String title) async {
    final key = 'Todo $id';
    final task = Todo(
      id: id,
      title: title,
    );
    final taskMap = ModelMapper.todoToMap(task);
    final taskJSON = ModelMapper.toJson(taskMap);

    await _sharedService.setData(key, taskJSON);
  }

  Future<Todo> getTask(int id) async {
    final key = 'Todo $id';
    final todoJSON = await _sharedService.getData(key);
    final apiTodo = ApiTodo.fromJson(todoJSON);
    final task = ModelMapper.todoFromJSON(apiTodo);
    return task;
  }

  Future<void> updateTask({
    required int id,
    String? title,
    TodoStatus? status,
    User? performer,
  }) async {
    final task = await getTask(id);
    final key = 'Todo $id';

    if (status != null) task.updateStatus(status);
    if (performer != null) task.updatePerformer(performer);

    if (title != null) {
      final editedTask = Todo(
        id: task.id,
        title: title,
      );
      editedTask.updateStatus(task.status);
      if (task.performer != null) editedTask.updatePerformer(task.performer!);
      final editedTaskMap = ModelMapper.todoToMap(editedTask);
      final editedTaskJSON = ModelMapper.toJson(editedTaskMap);
      await _sharedService.updateData(key, editedTaskJSON);
    } else {
      final taskMap = ModelMapper.todoToMap(task);
      final taskJSON = ModelMapper.toJson(taskMap);
      await _sharedService.updateData(key, taskJSON);
    }
  }

  Future<void> removeTask(int id) async {
    final key = 'Todo $id';
    await _sharedService.removeData(key);
  }
}
