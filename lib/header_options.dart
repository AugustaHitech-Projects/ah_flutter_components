import 'api_constants.dart';

class HeaderOptions {
  /// Based on the bool, 'Authorization' will be added to the header.
  /// The default value is 'true'. 'Authorization' will be added in the format 'Bearer token_value'.
  /// Token will be taken from the shared preference saved with the keyword 'KEY_TOKEN'.
  bool requireToken;

  /// The request Content-Type. The default value is 'application/json'.
  /// If empty string is passed, then default value will be taken.
  String contentType;

  /// Http request additional headers need to append other than 'Authorization' and 'Content-Type'
  Map<String, dynamic>? additionalHeaders;

  HeaderOptions({
    this.requireToken = true,
    this.contentType = ApiConstant.contentTypeValue,
    this.additionalHeaders,
  });
}
