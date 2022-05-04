import 'body_request.dart';

// Для создания тела запроса. Может потребоваться позже
class GetUserBody extends BodyRequest {
  GetUserBody();

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
