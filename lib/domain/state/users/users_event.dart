part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {}

class UsersGetAll extends UsersEvent {
  @override
  List<Object?> get props => [];
}
