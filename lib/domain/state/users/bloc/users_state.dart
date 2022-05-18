part of 'users_bloc.dart';

abstract class UsersState extends Equatable {}

class UsersInitial extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersSuccess extends UsersState {
  final List<User> users;
  UsersSuccess(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersFailure extends UsersState {
  final String error;
  UsersFailure(this.error);

  @override
  List<Object?> get props => [error];
}
