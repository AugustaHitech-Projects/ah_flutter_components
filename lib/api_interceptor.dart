import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'header_options.dart';

class ApiInterceptor extends Interceptor {
  final HeaderOptions headerOptions;

  ApiInterceptor(this.headerOptions);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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
    // print("Headers////");
    // options.headers.forEach((k, v) => print('$k: $v'));

    return super.onRequest(options, handler);
  }

  Future<String> _getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString(ApiConstant.KEY_TOKEN) ?? '';
    return token;
  }
}
