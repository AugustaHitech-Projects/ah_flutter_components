import 'dart:io';

import 'package:api_handler/api_errors.dart';
import 'package:dio/dio.dart';

class CustomException implements Exception {
  late dynamic error;

  CustomException.fromDioError(
      DioException dioError, bool? handleResponseError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        error = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        error = 'Connection timed out.';
        break;
      case DioExceptionType.receiveTimeout:
        error = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        error = 'Request send timeout.';
        break;
      case DioExceptionType.badResponse:
        error = handleResponseError == true
            ? ApiErrors.fromStatusCode(dioError.response?.statusCode)
            : dioError.response?.data;
        break;
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
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
