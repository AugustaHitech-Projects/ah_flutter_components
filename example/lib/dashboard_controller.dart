import 'dart:async';
import 'dart:io';
import 'package:example/dashboard_service.dart';
import 'package:example/tourist_list_response.dart';
import 'package:flutter/material.dart';

import 'login_response.dart';

class DashboardController with ChangeNotifier {
  String errorMessage = "";
  bool isLoading = false;
  List<TouristDetail> itemList = [];

  DashboardController() {
    isLoading = true;
    _signIn();
  }

  Future<void> _signIn() async {
    try {
      TouristListResponse response = await DashboardService().getTouristList();
      if (response.productList?.isNotEmpty == true) {
        itemList = response.productList ?? [];
      } else {
        errorMessage = "No Data Found";
      }
      isLoading = false;
      notifyListeners();
    } on SocketException {
      print("Socket Exception");
      errorMessage = "No Internet Connection";
      isLoading = false;
      notifyListeners();
    } catch (onError) {
      print("catch fetchAppDetails");
      print(onError);
      errorMessage = "Catch";
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    try {
      LoginResponse response = await DashboardService()
          .loginEmail(email: "athira+inr@augusta.no", password: "1234567890");
      isLoading = false;
      notifyListeners();
    } on SocketException {
      print("Socket Exception");
      errorMessage = "No Internet Connection";
      isLoading = false;
      notifyListeners();
    } catch (onError) {
      errorMessage = "Catch";
      isLoading = false;
      notifyListeners();
    }
  }
}
