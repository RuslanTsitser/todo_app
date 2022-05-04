import 'package:todo_app/data/repository/auth_data_repository.dart';
import 'package:todo_app/domain/repository/auth_repository.dart';
import 'package:todo_app/internal/api_module.dart';
import 'package:todo_app/internal/shared_module.dart';

// Связующая точка
class RepositoryModule {
  static AuthRepository? _authRepository;

  static AuthRepository authRepository() {
    _authRepository ??= AuthDataRepository(
      ApiModule.apiUtil(),
      SharedModule.sharedUtil(),
    );
    return _authRepository!;
  }
}
