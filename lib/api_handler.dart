library api_handler;

import 'dart:async';
import 'package:dio/dio.dart';
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
    Response<dynamic> response = await getDioIns(headerOptions).get(url);
    dynamic responseJson = _response(response);
    return responseJson;
  }

  Future<dynamic> post(
      {required String url,
      Map<String, dynamic>? body,
      HeaderOptions? headerOptions}) async {
    Response<dynamic> response =
        await getDioIns(headerOptions).post(url, data: body);
    dynamic responseJson = _response(response);
    return responseJson;
  }

  Future<dynamic> delete(
      {required String url, HeaderOptions? headerOptions}) async {
    Response<dynamic> response = await getDioIns(headerOptions).delete(url);
    dynamic responseJson = _response(response);
    return responseJson;
  }

  Future<dynamic> put(
      {required String url,
      Map<String, dynamic>? body,
      HeaderOptions? headerOptions}) async {
    Response<dynamic> response =
        await getDioIns(headerOptions).put(url, data: body);
    dynamic responseJson = _response(response);
    return responseJson;
  }

  dynamic _response(Response<dynamic> response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 202:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 403:
        throw UnauthorisedException(response.data.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
