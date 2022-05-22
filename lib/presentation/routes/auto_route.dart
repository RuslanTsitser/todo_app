import 'package:auto_route/auto_route.dart';
import 'package:todo_app/presentation/pages/login_page.dart';
import 'package:todo_app/presentation/pages/splash_page.dart';
import 'package:todo_app/presentation/pages/todo_list_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: LoginPage, path: '/login'),
    MaterialRoute(page: TodoListPage, path: '/todo-list'),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}
