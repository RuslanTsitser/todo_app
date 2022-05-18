import 'package:riverpod/riverpod.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthNotifier(this._authRepository) : super(const AuthState.initial());

  Future<void> loginWithUsername(String username, String password) async {
    final authenticated = await _authRepository.login(username, password);
    state = authenticated
        ? const AuthState.authenticated()
        : const AuthState.failure('Неверные username или password');
  }

  Future<void> loginWithToken() async {
    final authenticated = await _authRepository.loginWithToken();
    state = authenticated
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }
}
