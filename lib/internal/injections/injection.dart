import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/internal/injections/injection.config.dart';

@injectableInit
void configureInjection(String environment) =>
    $initGetIt(GetIt.instance, environment: environment);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
