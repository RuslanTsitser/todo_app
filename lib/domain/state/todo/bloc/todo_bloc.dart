import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/state/todo/riverpod/todo_filter_notifier.dart';

import '../../../../internal/simple_singletones/repository_module.dart';
import '../../../model/export_model.dart';
import '../../../repository/auth_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late AuthRepository _authRepository;
  late TodoFilterNotifier _todoFilterNotifier;
  TodoBloc() : super(TodoInitial()) {
    _authRepository = RepositoryModule.authRepository();
    _todoFilterNotifier = TodoFilterNotifier();

    on<TodoGetList>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.getTodoList();
          todoList.isNotEmpty
              ? emit(TodoSuccess(todoList))
              : emit(TodoEmptyList());
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoAdd>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.createTodo(
            event.id,
            event.title,
          );

          emit(TodoSuccess(todoList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoRemove>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.deleteTodo(
            event.id,
          );

          todoList.isNotEmpty
              ? emit(TodoSuccess(todoList))
              : emit(TodoEmptyList());
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoUpdateStatus>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.updateTodo(
            id: event.id,
            newStatus: event.status,
          );
          emit(TodoSuccess(todoList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoEditTitle>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.updateTodo(
            id: event.id,
            newTitle: event.title,
          );
          emit(TodoSuccess(todoList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoSetPerformer>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.updateTodo(
            id: event.id,
            newPerformer: event.performer,
          );
          emit(TodoSuccess(todoList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoChangeTitle>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.updateTodo(
            id: event.id,
            newTitle: event.value,
          );
          emit(TodoSuccess(todoList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );

    on<TodoFilterOrSearch>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.getTodoList();

          if (event.status == null && event.value == null) {
            _todoFilterNotifier.clearFilter();
          }
          if (event.status != null) {
            _todoFilterNotifier.changeStatusFilter(event.status!);
          }
          if (event.value != null) {
            _todoFilterNotifier.changeSearchFilter(event.value!);
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
          emit(TodoSuccess(filteredList));
        } catch (e) {
          emit(TodoFailure(e.toString()));
        }
      },
    );
  }
}
