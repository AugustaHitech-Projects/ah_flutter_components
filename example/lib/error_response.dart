import '../../theme/app_constants.dart';
import '../../theme/app_errors.dart';

class ErrorResponse {
  int? statusCode;
  String? errorMessage;

  ErrorResponse.fromJson(Map<String, dynamic> obj) {
    statusCode = obj['status_code'] ?? '';
    errorMessage = obj['displayMessage'] ?? '';
  }

  ErrorResponse.fromLoginJson(Map<String, dynamic> obj) {
    statusCode = obj['statusCode'] ?? 0;
    if (statusCode == AppConstants.emailPhoneErrorCode) {
      errorMessage = AppErrors.notExistEmail;
    } else if (statusCode == AppConstants.deviceErrorCode) {
      errorMessage = "Login Device Limit Exceeded";
    } else {
      errorMessage = obj['displayMessage'] ?? '';
    }
  }

  ErrorResponse.fromSignupJson(Map<String, dynamic> obj) {
    statusCode = obj['statusCode'] ?? 0;
    if (statusCode == AppConstants.emailPhoneAlreadyExistsErrorCode) {
      errorMessage = AppErrors.alreadyExistEmail;
      print('gg');
    } else {
      errorMessage = obj['displayMessage'] ?? '';
      print('hh');
    }
  }
}
