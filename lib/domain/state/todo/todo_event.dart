part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {}

class TodoGetList extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoAdd extends TodoEvent {
  final String id;
  final String title;
  TodoAdd(this.id, this.title);
  @override
  List<Object?> get props => [id, title];
}

class TodoUpdateStatus extends TodoEvent {
  final String id;
  final TodoStatus status;

  TodoUpdateStatus(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class TodoEditTitle extends TodoEvent {
  final String id;
  final String title;

  TodoEditTitle(this.id, this.title);

  @override
  List<Object?> get props => [id, title];
}

class TodoSetPerformer extends TodoEvent {
  final String id;
  final User performer;

  TodoSetPerformer(this.id, this.performer);

  @override
  List<Object?> get props => [id, performer];
}

class TodoRemove extends TodoEvent {
  final String id;

  TodoRemove(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoFilter extends TodoEvent {
  final TodoStatus status;
  TodoFilter(this.status);
  @override
  List<Object?> get props => [status];
}

class TodoFilterReset extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoSearch extends TodoEvent {
  final String value;
  TodoSearch(this.value);
  @override
  List<Object?> get props => [value];
}

class TodoChangeTitle extends TodoEvent {
  final String id;
  final String value;
  TodoChangeTitle(this.id, this.value);
  @override
  List<Object?> get props => [id, value];
}
