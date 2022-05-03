import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'export_model.dart';

enum TodoStatus { waiting, inProgress, completed }

extension TodoStatusExtension on TodoStatus {
  String get name => describeEnum(this);
}

// ignore: must_be_immutable
class Todo extends Equatable {
  final int id;
  final String title;
  TodoStatus _status = TodoStatus.waiting;
  User? _performer;

  Todo({
    this.id = 0,
    this.title = '',
  });

  TodoStatus get status => _status;
  User? get performer => _performer;

  void updateStatus(TodoStatus newStatus) {
    _status = newStatus;
  }

  void updatePerformer(User performer) {
    _performer = performer;
  }

  @override
  List<Object?> get props => [id, title];
}
