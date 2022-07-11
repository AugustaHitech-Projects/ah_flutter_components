import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[ApiConstant.contentType] = ApiConstant.contentTypeValue;
    String token = await getToken();
    if (token.isEmpty == true) {
      return super.onRequest(options, handler);
    }
    options.headers[ApiConstant.authorization] = ApiConstant.bearerKey + token;
    print(options.path);
    print(options.data);
    return super.onRequest(options, handler);
  }

  Future<String> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString(ApiConstant.KEY_TOKEN) ?? '';
    print('getToken: $token');
    return token;
  }
}
