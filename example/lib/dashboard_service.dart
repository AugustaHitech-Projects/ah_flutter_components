import 'package:api_handler/api_handler.dart';
import 'package:api_handler/header_options.dart';
import 'login_response.dart';
import 'tourist_list_response.dart';

class DashboardService {
  ApiHandler apiHandler = ApiHandler();

  Future<TouristListResponse> getTouristList() async {
    dynamic response = await apiHandler.get(
      url: "http://restapi.adequateshop.com/api/Tourist?page=2",
      headerOptions: HeaderOptions(
          requireToken: true,
          contentType: "",
          additionalHeaders: {"auth": "author", "bear": "bearer"}),
    );
    return TouristListResponse.fromJson(response);
  }

  Future<LoginResponse> loginEmail(
      {required String email, required String password}) async {
    dynamic deviceInfo = null;
    Map<String, String> body = <String, String>{
      "emailId": email,
      "password": password,
      "deviceId": deviceInfo?.id ?? "",
      "deviceName": deviceInfo?.name ?? "",
      "deviceToken": deviceInfo?.fcmToken ?? ""
    };
    dynamic response = await apiHandler.post(
        url:
            "https://jetsynthesys-api-app.augustasoftsol.com/app/api/auth/email/login?userType=user",
        body: body,
        headerOptions: HeaderOptions(handleResponseError: false, refreshTokenFn: () async {
          // await refreshTokenAPI();
          // sharedPreference.setToken();
        }));
    return LoginResponse.fromJson(response);
  }
}
