class TouristListResponse {
  List<TouristDetail>? productList;

  TouristListResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json["data"] is List) {
      productList = json["data"].map<TouristDetail>((dynamic e) {
        return TouristDetail.fromJson(e);
      }).toList();
    }
  }
}

class TouristDetail {
  int? id;
  String? name;
  String? email;
  String? image;

  TouristDetail.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json["id"];
    name = json["tourist_name"];
    email = json["tourist_email"];
    image = json["tourist_profilepicture"];
  }
}
