part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoSuccess extends TodoState {
  final List<Todo> todoList;
  final DateTime _dateTime = DateTime.now();
  TodoSuccess(this.todoList);
  @override
  List<Object?> get props => [todoList, _dateTime];
}

class TodoEmptyList extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoFailure extends TodoState {
  final String error;
  TodoFailure(this.error);
  @override
  List<Object?> get props => [error];
}
