import 'package:riverpod/riverpod.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';

import '../../../model/export_model.dart';
import 'todo_state.dart';

class TodoNotifier extends StateNotifier<TodoState> {
  final AuthRepository _authRepository;
  TodoNotifier(this._authRepository) : super(const TodoState.initial());

  void getList() async {
    try {
      final todoList = await _authRepository.getTodoList();
      state = todoList.isNotEmpty
          ? TodoState.success(todoList)
          : const TodoState.emptyList();
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void addTodo(String id, String title) async {
    try {
      final todoList = await _authRepository.createTodo(
        id,
        title,
      );

      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void removeTodo(String id) async {
    try {
      final todoList = await _authRepository.deleteTodo(
        id,
      );

      state = todoList.isNotEmpty
          ? TodoState.success(todoList)
          : const TodoState.emptyList();
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void updateStatus(String id, TodoStatus status) async {
    try {
      final todoList = await _authRepository.updateTodo(
        id: id,
        newStatus: status,
      );
      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void editTitle(String id, String title) async {
    try {
      final todoList = await _authRepository.updateTodo(
        id: id,
        newTitle: title,
      );
      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void setPerformer(String id, User performer) async {
    try {
      final todoList = await _authRepository.updateTodo(
        id: id,
        newPerformer: performer,
      );
      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void filter(TodoStatus status) async {
    try {
      final todoList = await _authRepository.getTodoList();
      final filteredList = todoList.where(
        (element) {
          if (element.status == status) {
            return true;
          } else {
            return false;
          }
        },
      ).toList();
      state = TodoState.success(filteredList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void filterReset() async {
    try {
      final todoList = await _authRepository.getTodoList();

      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void search(String value) async {
    try {
      final todoList = await _authRepository.getTodoList();
      final filteredList = todoList.where(
        (element) {
          if (element.title.contains(value)) {
            return true;
          } else {
            return false;
          }
        },
      ).toList();
      state = TodoState.success(filteredList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }

  void changeTitle(String id, String value) async {
    try {
      final todoList = await _authRepository.updateTodo(
        id: id,
        newTitle: value,
      );
      state = TodoState.success(todoList);
    } catch (e) {
      state = TodoState.failure(e.toString());
    }
  }
}
