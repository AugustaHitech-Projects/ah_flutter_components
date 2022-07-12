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
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return itemField(index, context);
      },
      itemCount: _dashboardController?.itemList.length ?? 0,
    );
  }

  Widget itemField(int index, BuildContext context) {
    TouristDetail? item = _dashboardController?.itemList.elementAt(index);
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ]),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              item?.image ?? "",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Text(
                item?.name ?? "",
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
