import 'package:riverpod/riverpod.dart';
import '../../../repository/auth_repository.dart';
import 'users_state.dart';

class UsersNotifier extends StateNotifier<UsersState> {
  final AuthRepository _authRepository;
  UsersNotifier(this._authRepository) : super(const UsersState.initial());

  Future<void> getAllUsers() async {
    try {
      final users = await _authRepository.getUsers();
      state = UsersState.success(users);
    } catch (e) {
      state = UsersState.failure(e.toString());
    }
  }
}
