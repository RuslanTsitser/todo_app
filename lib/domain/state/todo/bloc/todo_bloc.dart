import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../internal/repository_module.dart';
import '../../../model/export_model.dart';
import '../../../repository/auth_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late AuthRepository _authRepository;
  TodoBloc() : super(TodoInitial()) {
    _authRepository = RepositoryModule.authRepository();

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

    on<TodoFilter>((event, emit) async {
      try {
        final todoList = await _authRepository.getTodoList();
        final filteredList = todoList.where(
          (element) {
            if (element.status == event.status) {
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
    });

    on<TodoFilterReset>((event, emit) async {
      try {
        final todoList = await _authRepository.getTodoList();

        emit(TodoSuccess(todoList));
      } catch (e) {
        emit(TodoFailure(e.toString()));
      }
    });

    on<TodoSearch>(
      (event, emit) async {
        try {
          final todoList = await _authRepository.getTodoList();
          final filteredList = todoList.where(
            (element) {
              if (element.title.contains(event.value)) {
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
  }
}
