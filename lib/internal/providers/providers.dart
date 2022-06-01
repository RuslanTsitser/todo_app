import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/data/api/api_util.dart';
import 'package:todo_app/data/api/service/api_service.dart';
import 'package:todo_app/data/repository/auth_data_repository.dart';
import 'package:todo_app/data/shared/service/shared_service.dart';
import 'package:todo_app/data/shared/shared_util.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';
import 'package:todo_app/domain/state/todo/riverpod/todo_filter_notifier.dart';
import 'package:todo_app/presentation/routes/auto_route.gr.dart';

import '../../domain/state/auth/riverpod/auth_notifier.dart';
import '../../domain/state/auth/riverpod/auth_state.dart';
import '../../domain/state/todo/riverpod/todo_notifier.dart';
import '../../domain/state/todo/riverpod/todo_state.dart';
import '../../domain/state/users/riverpod/users_notifier.dart';
import '../../domain/state/users/riverpod/users_state.dart';

// For cashing data
final _sharedProvider = Provider(
  (ref) => SharedUtil(SharedServiceImp()),
);

// For fetching data from the Internet
final _apiProvider = Provider(
  (ref) => ApiUtil(ApiService()),
);

// Instance of AuthRepository
final _repositoryProvider = Provider<AuthRepository>(
  (ref) => AuthDataRepository(
    ref.watch(_apiProvider),
    ref.watch(_sharedProvider),
  ),
);

// An instance of AppRouter
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

// Initial checking if a token exists
final initialProvider = FutureProvider((ref) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.loginWithToken();
});

// Providing states
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(_repositoryProvider)),
);

final _todoFilterNotifierProvider = Provider<TodoFilterNotifier>(
  (ref) => TodoFilterNotifier(),
);

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, TodoState>(
  (ref) => TodoNotifier(
    ref.watch(_repositoryProvider),
    ref.watch(_todoFilterNotifierProvider),
  ),
);

final usersNotifierProvider = StateNotifierProvider<UsersNotifier, UsersState>(
  (ref) => UsersNotifier(ref.watch(_repositoryProvider)),
);
