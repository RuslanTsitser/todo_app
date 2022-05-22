import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/export_model.dart';

part 'users_state.freezed.dart';

@freezed
class UsersState with _$UsersState {
  const UsersState._();

  const factory UsersState.initial() = _Initial;
  const factory UsersState.success(
    List<User> users,
  ) = _Success;
  const factory UsersState.failure(
    String error,
  ) = _Failure;
}
