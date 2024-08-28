import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/views/sign_up-in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../data/authentication_functions.dart';
import '../main.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';

class RightSideListView extends StatefulWidget {
  const RightSideListView({super.key});

  @override
  State<RightSideListView> createState() => _RightSideListViewState();
}

class _RightSideListViewState extends State<RightSideListView> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);

    return Consumer2<ViewProvider, DataProvider>(
        builder: (context, viewProvider, dataProvider, child) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: d.height20),
            width: double.infinity,
            height: d.height200,
            color: colors.mainYallo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/photos/avatar1.png",
                  height: d.height100,
                ),
                Text(
                  dataProvider.email ?? "example@domain.com",
                  style: TextStyle(
                      fontSize: d.fontSize21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: d.height100 - d.height20 * 2.3,
          ),
          TextButton(
              onPressed: () {
                viewProvider.toBusListView();
              },
              child: Text(
                "قائمة الباصات",
                style: TextStyle(
                  fontSize: d.fontSize18,
                ),
              )),
          SizedBox(
            height: d.height20 * 2,
          ),
          TextButton(
              onPressed: () {
                viewProvider.toDailyGainView(
                    dataProvider.getUserDocument.collection('dailyGain'), true);
              },
              child: Text(
                "الربح اليومي",
                style: TextStyle(
                  fontSize: d.fontSize18,
                ),
              )),
          SizedBox(
            height: d.height20 * 2,
          ),
          TextButton(
              onPressed: () {
                viewProvider.toMonthlyGainView(
                    dataProvider.getUserDocument.collection("dailyGain"), true);
              },
              child: Text(
                "الربح الشهري",
                style: TextStyle(
                  fontSize: d.fontSize18,
                ),
              )),
          SizedBox(
            height: d.height20 * 2,
          ),
          TextButton(
              onPressed: () {
                viewProvider.toFromToGainView(
                    dataProvider.getUserDocument.collection("dailyGain"), true);
              },
              child: Text(
                "الربح من - الى",
                style: TextStyle(
                  fontSize: d.fontSize18,
                ),
              )),
          SizedBox(
            height: d.height100,
          ),
          TextButton(
              onPressed: () {
                AuthenticationFunctions().logout();
                viewProvider.toDefaultLeft();
                viewProvider.toSignIn();
              },
              child: Text(
                "تسجيل خروج",
                style: TextStyle(
                  fontSize: d.fontSize18,
                ),
              )),
        ],
      );
    });
  }
}
