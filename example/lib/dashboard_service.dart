import 'package:api_handler/api_handler.dart';
import 'package:api_handler/header_options.dart';
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
}
