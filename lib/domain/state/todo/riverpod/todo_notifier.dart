import 'package:riverpod/riverpod.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';
import 'package:todo_app/domain/state/todo/riverpod/todo_filter_notifier.dart';

import '../../../model/export_model.dart';
import 'todo_state.dart';

class TodoNotifier extends StateNotifier<TodoState> {
  final AuthRepository _authRepository;
  final TodoFilterNotifier _todoFilterNotifier;
  TodoNotifier(
    this._authRepository,
    this._todoFilterNotifier,
  ) : super(const TodoState.initial());

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

  void filterOrSearch({TodoStatus? status, String? value}) async {
    try {
      final todoList = await _authRepository.getTodoList();

      if (status == null && value == null) {
        _todoFilterNotifier.clearFilter();
      }
      if (status != null) {
        _todoFilterNotifier.changeStatusFilter(status);
      }
      if (value != null) {
        _todoFilterNotifier.changeSearchFilter(value);
      }

      final _status = _todoFilterNotifier.statusFilter;
      final _searchValue = _todoFilterNotifier.searchFilter;

      final filteredList = todoList.where(
        (element) {
          if ((_status != null ? element.status == _status : true) &&
              (_searchValue != null
                  ? element.title.contains(_searchValue)
                  : true)) {
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
