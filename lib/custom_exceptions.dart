import 'package:api_handler/api_errors.dart';
import 'package:dio/dio.dart';

class CustomException implements Exception {
  late dynamic error;

  CustomException.fromDioError(DioError dioError, bool? handleResponseError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        error = 'Request to the server was cancelled.';
        break;
      case DioErrorType.connectTimeout:
        error = 'Connection timed out.';
        break;
      case DioErrorType.receiveTimeout:
        error = 'Receiving timeout occurred.';
        break;
      case DioErrorType.sendTimeout:
        error = 'Request send timeout.';
        break;
      case DioErrorType.response:
        error = handleResponseError == true
            ? ApiErrors.fromStatusCode(dioError.response?.statusCode)
            : dioError.response?.data;
        break;
      case DioErrorType.other:
        if (dioError.message.contains('SocketException')) {
          error = 'No Internet.';
          break;
        }
        error = 'Unexpected error occurred.';
        break;
      default:
        error = 'Something went wrong';
        break;
    }
  }
}
