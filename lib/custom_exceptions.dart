import 'package:api_handler/api_errors.dart';
import 'package:dio/dio.dart';

class CustomException implements Exception {
  late String errorMessage;

  CustomException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioErrorType.connectTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioErrorType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioErrorType.response:
        errorMessage =
            ApiErrors.fromStatusCode(dioError.response?.statusCode);
        break;
      case DioErrorType.other:
        if (dioError.message.contains('SocketException')) {
          errorMessage = 'No Internet.';
          break;
        }
        errorMessage = 'Unexpected error occurred.';
        break;
      default:
        errorMessage = 'Something went wrong';
        break;
    }
  }

  @override
  String toString() => errorMessage;
}
