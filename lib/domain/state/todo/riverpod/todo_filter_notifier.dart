import 'package:todo_app/domain/model/export_model.dart';

class TodoFilterNotifier {
  String? _searchFilter;
  TodoStatus? _statusFilter;

  String? get searchFilter => _searchFilter;
  TodoStatus? get statusFilter => _statusFilter;

  void changeSearchFilter(String value) {
    _searchFilter = value;
  }

  void changeStatusFilter(TodoStatus status) {
    _statusFilter = status;
  }

  void clearFilter() {
    _searchFilter = null;
    _statusFilter = null;
  }
}
