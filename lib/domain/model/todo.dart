import 'package:equatable/equatable.dart';

import 'export_model.dart';

// Основной класс для Todo
enum TodoStatus { waiting, inProgress, completed }

extension TodoStatusExtension on TodoStatus {
  String get name {
    switch (this) {
      case TodoStatus.completed:
        return 'Выполнено';
      case TodoStatus.inProgress:
        return 'В работе';
      case TodoStatus.waiting:
        return 'Ожидание';
    }
  }
}

// ignore: must_be_immutable
class Todo extends Equatable {
  final String id;
  final String title;
  TodoStatus _status = TodoStatus.waiting;
  User? _performer;

  Todo({
    this.id = '',
    this.title = '',
  });

  TodoStatus get status => _status;
  User? get performer => _performer;

  void updateStatus(TodoStatus newStatus) {
    _status = newStatus;
  }

  void updatePerformer(User? performer) {
    _performer = performer;
  }

  @override
  List<Object?> get props => [id, title];
}
