part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class LoginWithUsername extends AuthEvent {
  final String username;
  final String password;
  LoginWithUsername(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

class LoginWithToken extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Logout extends AuthEvent {
  @override
  List<Object?> get props => [];
}
