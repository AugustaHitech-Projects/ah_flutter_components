import 'package:api_handler/api_handler.dart';
import 'tourist_list_response.dart';

class DashboardService {
  ApiHandler apiHandler = ApiHandler();

  Future<TouristListResponse> getTouristList() async {
    dynamic response = await apiHandler.post(
        url: "http://restapi.adequateshop.com/api/Tourist?page=2");
    return TouristListResponse.fromJson(response);
  }
}
