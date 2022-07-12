import 'package:example/tourist_list_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static DashboardController? _dashboardController;

  @override
  Widget build(BuildContext context) {
    _dashboardController = Provider.of<DashboardController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: buildBodyWidget(),
    );
  }

  Widget buildBodyWidget() {
    if (_dashboardController?.isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    } else if (_dashboardController?.itemList.isNotEmpty == true) {
      return touristListField();
    } else if (_dashboardController?.errorMessage.isNotEmpty == true) {
      return Center(child: Text(_dashboardController?.errorMessage ?? ""));
    } else {
      return const Center(
          child: Text("Something went wrong. Please try again later"));
    }
  }

  Widget touristListField() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return itemField(index, context);
      },
      itemCount: _dashboardController?.itemList.length ?? 0,
    );
  }

  Widget itemField(int index, BuildContext context) {
    TouristDetail? item = _dashboardController?.itemList.elementAt(index);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ]),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Text(
              item?.name?.split("").first.toUpperCase() ?? "",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.name
                          ?.split(" ")
                          .map((s) => s[0].toUpperCase() + s.substring(1))
                          .join(" ") ??
                      "",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                    item?.email ?? "",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Text(
                  item?.location ?? "",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
