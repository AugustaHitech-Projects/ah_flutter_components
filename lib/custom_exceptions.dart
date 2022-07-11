import 'api_errors.dart';

class CustomException implements Exception {
  final dynamic _message;
  final String? _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, ApiErrors.communicationError);
}

class BadRequestException extends CustomException {
  BadRequestException([String? message])
      : super(message, ApiErrors.invalidRequest);
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([String? message])
      : super(message, ApiErrors.unauthorised);
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message])
      : super(message, ApiErrors.invalidInput);
}
