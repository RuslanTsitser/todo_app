import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/domain/state/states.dart';
import 'package:todo_app/internal/providers/providers.dart';
import 'package:todo_app/presentation/pages/splash_page.dart';
import 'package:todo_app/presentation/pages/todo_list_page.dart';
import 'package:todo_app/presentation/routes/auto_route.gr.dart';

import '../presentation/pages/login_page.dart';
import '../presentation/properties/app_theme.dart';
import '../../domain/state/freezed_states.dart' as f;

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              _navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            }
            if (state is AuthSuccess) {
              _navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const TodoListPage()),
                  (route) => false);
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: child,
        );
      },
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => const SplashPage(),
      ),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const SplashPage(),
      //   '/login-page': (context) => const LoginPage(),
      //   '/todo-list-page': (context) => const TodoListPage(),
      // },
    );
  }
}

class ApplicationRiverpod extends ConsumerWidget {
  const ApplicationRiverpod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final appRouter = ref.watch(appRouterProvider);
    ref.watch(initialProvider);
    ref.listen<f.AuthState>(authNotifierProvider, (previous, next) {
      final appRouter = ref.watch(appRouterProvider);
      if (next == const f.AuthState.authenticated()) {
        ref
          ..watch(todoNotifierProvider.notifier).getList()
          ..watch(usersNotifierProvider.notifier).getAllUsers();
        appRouter.pushAndPopUntil(
          const TodoListRoute(),
          predicate: (route) => false,
        );
      }
      if (next == const f.AuthState.unauthenticated()) {
        appRouter.pushAndPopUntil(
          const LoginRoute(),
          predicate: (route) => false,
        );
      }
    });

    return MaterialApp.router(
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: appRouter.delegate(),
    );
  }
}
