import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/export_model.dart';

part 'todo_state.freezed.dart';

@Freezed(
  equal: false,
)
class TodoState with _$TodoState {
  const TodoState._();

  const factory TodoState.initial() = _Initial;
  const factory TodoState.success(
    List<Todo> todoList,
  ) = _Success;
  const factory TodoState.emptyList() = _EmptyList;
  const factory TodoState.failure(
    String error,
  ) = _Failure;
}
