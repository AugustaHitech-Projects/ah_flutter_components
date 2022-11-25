library api_handler;

import 'dart:async';
import 'package:dio/dio.dart';
import 'api_errors.dart';
import 'api_interceptor.dart';
import 'custom_exceptions.dart';
import 'header_options.dart';

class ApiHandler {
  Dio getDioIns(HeaderOptions? headerOptions) {
    Dio dio = Dio();
    dio.interceptors.add(ApiInterceptor(headerOptions ?? HeaderOptions()));
    return dio;
  }

  Future<dynamic> get(
      {required String url, HeaderOptions? headerOptions}) async {
    try {
      Response<dynamic> response = await getDioIns(headerOptions).get(url);
      dynamic responseJson = _response(response);
      return responseJson;
    } on DioError catch (err) {
      throw CustomException.fromDioError(err, headerOptions?.handleResponseError).error;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
      {required String url,
      Map<String, dynamic>? body,
      HeaderOptions? headerOptions}) async {
    try {
      Response<dynamic> response = await getDioIns(headerOptions).post(url, data: body);
      dynamic responseJson = _response(response);
      return responseJson;
    } on DioError catch (err) {
      throw CustomException.fromDioError(err, headerOptions?.handleResponseError).error;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
      {required String url, HeaderOptions? headerOptions}) async {
    try {
      Response<dynamic> response = await getDioIns(headerOptions).delete(url);
      dynamic responseJson = _response(response);
      return responseJson;
    } on DioError catch (err) {
      throw CustomException.fromDioError(err, headerOptions?.handleResponseError).error;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
      {required String url,
      Map<String, dynamic>? body,
      HeaderOptions? headerOptions}) async {
    try {
      Response<dynamic> response = await getDioIns(headerOptions).put(url, data: body);
      dynamic responseJson = _response(response);
      return responseJson;
    } on DioError catch (err) {
      throw CustomException.fromDioError(err, headerOptions?.handleResponseError).error;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadFile(
      {required String url,
        dynamic? body,
        HeaderOptions? headerOptions}) async {
    try {
      Response<dynamic> response = await getDioIns(headerOptions).put(url, data: body);
      dynamic responseJson = _response(response);
      return responseJson;
    } on DioError catch (err) {
      throw CustomException.fromDioError(err, headerOptions?.handleResponseError).error;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> retry(RequestOptions? requestOptions) async {
    final options = Options(
        method: requestOptions?.method,
        headers: requestOptions?.headers,
        responseType: requestOptions?.responseType);

    return Dio().request(requestOptions?.path ?? "",
        data: requestOptions?.data,
        queryParameters: requestOptions?.queryParameters,
        options: options);
  }

  dynamic _response(Response<dynamic> response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw ApiErrors.fromStatusCode(response.statusCode);
    }
  }
}
