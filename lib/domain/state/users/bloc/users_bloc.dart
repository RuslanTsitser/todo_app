import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../internal/simple_singletones/repository_module.dart';
import '../../../model/export_model.dart';
import '../../../repository/auth_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  late AuthRepository _authRepository;
  UsersBloc() : super(UsersInitial()) {
    _authRepository = RepositoryModule.authRepository();
    on<UsersGetAll>(
      (event, emit) async {
        try {
          final users = await _authRepository.getUsers();
          emit(UsersSuccess(users));
        } catch (e) {
          emit(UsersFailure(e.toString()));
        }
      },
    );
  }
}
