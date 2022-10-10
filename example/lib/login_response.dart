class LoginResponse {
  bool? success;
  String? token;
  String? errorMessage;

  LoginResponse.fromJson(Map<String, dynamic> obj) {
    success = obj['success'] ?? '';
    token = obj['bearer_token'] ?? '';
    errorMessage = obj['displayMessage'] ?? '';
  }
}
