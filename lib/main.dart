import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'domain/state/auth/bloc/auth_bloc.dart';
import 'domain/state/todo/bloc/todo_bloc.dart';
import 'domain/state/users/bloc/users_bloc.dart';
import 'internal/application.dart';

bool kTryRiverpod = false;

void main() {
  runApp(kTryRiverpod
      ? const ProviderScope(child: ApplicationRiverpod())
      : MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc()..add(LoginWithToken()),
            ),
            BlocProvider(
              create: (context) => TodoBloc(),
            ),
            BlocProvider(
              create: (context) => UsersBloc()..add(UsersGetAll()),
            ),
          ],
          child: const Application(),
        ));
}
