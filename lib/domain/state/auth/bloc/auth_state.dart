part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthUnauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
  @override
  List<Object?> get props => [error];
}
