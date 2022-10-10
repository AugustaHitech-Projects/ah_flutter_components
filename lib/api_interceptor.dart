import 'package:api_handler/api_handler.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'header_options.dart';

class ApiInterceptor extends Interceptor {
  final HeaderOptions headerOptions;

  ApiInterceptor(this.headerOptions);

  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Future<void> onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    if (headerOptions.additionalHeaders?.isNotEmpty == true) {
      options.headers.addAll(headerOptions.additionalHeaders!);
    }

    options.headers[ApiConstant.contentType] =
    headerOptions.contentType.isNotEmpty == true
        ? headerOptions.contentType
        : ApiConstant.contentTypeValue;

    if (headerOptions.requireToken == true) {
      String token = await _getToken();
      if (token.isNotEmpty == true) {
        options.headers[ApiConstant.authorization] =
            ApiConstant.bearerKey + token;
      }
    }
    logger.d('${options.method} => ${options.uri}'
        '\nHeaders => ${options.headers}'
        '\nRequest Data => ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Response => ${response.realUri}'
        '\nStatusCode => ${response.statusCode}'
        '\nData => ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError error, ErrorInterceptorHandler handler) async {
    logger.e('${error.requestOptions.method} => ${error.requestOptions.uri}'
        '\nError Code => ${error.response?.statusCode}'
        '\nMessage => ${error.message}');

    if (error.response?.statusCode == 401 && headerOptions.refreshTokenFn != null) {
      await headerOptions.refreshTokenFn?.call();
      return handler.resolve(await ApiHandler().retry(error.response?.requestOptions));
    }
    return handler.next(error);
  }

  Future<String> _getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString(ApiConstant.KEY_TOKEN) ?? '';
    return token;
  }
}
