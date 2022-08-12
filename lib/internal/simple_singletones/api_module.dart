import '../../data/api/api_util.dart';
import '../../data/api/service/api_service.dart';

class ApiModule {
  static ApiUtil? _apiUtil;

  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil(ApiService());
    return _apiUtil!;
  }
}
