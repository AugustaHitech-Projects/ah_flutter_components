import 'package:jetsynthesys/app/models/user_details_model.dart';

class LoginResponse {
  bool? success;
  String? token;
  String? errorMessage;
  UserDetails? userDetails;

  LoginResponse.fromJson(Map<String, dynamic> obj) {
    success = obj['success'] ?? '';
    token = obj['bearer_token'] ?? '';
    errorMessage = obj['displayMessage'] ?? '';
  }
}
