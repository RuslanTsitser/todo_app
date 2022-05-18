import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/pages/splash_screen.dart';
import 'package:todo_app/presentation/pages/todo_list_page.dart';

import '../domain/state/auth/auth_bloc.dart';
import '../domain/state/todo/todo_bloc.dart';
import '../domain/state/users/users_bloc.dart';
import 'pages/login_page.dart';
import 'properties/app_theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => TodoBloc(),
        ),
        BlocProvider(
          create: (context) => UsersBloc()..add(UsersGetAll()),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: AppTheme.dark,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login-page': (context) => const LoginPage(),
          '/todo-list-page': (context) => const TodoListPage(),
        },
      ),
    );
  }
}
