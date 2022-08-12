import 'package:todo_app/data/shared/service/shared_service.dart';

import '../../data/shared/shared_util.dart';

class SharedModule {
  static SharedUtil? _sharedUtil;

  static SharedUtil sharedUtil() {
    _sharedUtil ??= SharedUtil(SharedServiceImp());
    return _sharedUtil!;
  }
}
