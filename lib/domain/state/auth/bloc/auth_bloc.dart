import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';
import 'package:todo_app/internal/repository_module.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthRepository _authRepository;
  AuthBloc() : super(AuthInitial()) {
    _authRepository = RepositoryModule.authRepository();
    on<LoginWithUsername>(
      (event, emit) async {
        final success = await _authRepository.login(
          event.username,
          event.password,
        );
        if (success) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure('Неверные username или password'));
        }
      },
    );
    on<LoginWithToken>(
      (event, emit) async {
        final success = await _authRepository.loginWithToken();
        if (success) {
          emit(AuthSuccess());
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
    on<Logout>(
      (event, emit) async {
        try {
          await _authRepository.logout();
          emit(AuthUnauthenticated());
        } catch (e) {
          emit(AuthFailure(e.toString()));
        }
      },
    );
  }
}
