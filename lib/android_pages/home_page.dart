import 'dart:ffi';

import 'package:alghannam_transport/android_pages/new_bus_page.dart';
import 'package:alghannam_transport/android_pages/signIn_page.dart';
import 'package:alghannam_transport/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../data/authentication_functions.dart';
import '../utils/dimantions.dart';
import 'package:lottie/lottie.dart';

import 'bus_page.dart';
import 'daily_gain_page.dart';
import 'from_to_gain_page.dart';
import 'monthly_gain_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NewBusPage()));
        },
        backgroundColor: colors.mainYallo,
        child: const Icon(Icons.add),
      ),
      endDrawer: Drawer(
        width: d.width100 * 3,
        backgroundColor: colors.mainYallo3,
        child: Consumer<DataProvider>(builder: (context, dataProvider, child) {
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
                height: d.height100,
              ),
              TextButton(
                  onPressed: () {
                    /*  viewProvider.toDailyGainView(
                    dataProvider.getUserDocument.collection('dailyGain'), true);
              */
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DailyGainPage(
                            dailyGainColReference: dataProvider.getUserDocument
                                .collection('dailyGain'))));
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
                    /* viewProvider.toMonthlyGainView(
                    dataProvider.getUserDocument.collection("dailyGain"), true);
              */
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MonthlyGainPage(
                            dailyGainColReference: dataProvider.getUserDocument
                                .collection('dailyGain'))));
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
                    /*  viewProvider.toFromToGainView(
                    dataProvider.getUserDocument.collection("dailyGain"), true);
              */
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FromToGainPage(
                            dailyGainColReference: dataProvider.getUserDocument
                                .collection('dailyGain'))));
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignIn()));
                  },
                  child: Text(
                    "تسجيل خروج",
                    style: TextStyle(
                      fontSize: d.fontSize18,
                    ),
                  )),
            ],
          );
        }),
      ),
      appBar: AppBar(
        leading: SizedBox(width: d.width100 * 0.55),
        centerTitle: true,
        iconTheme: IconThemeData(size: d.height25 * 1.25, color: Colors.white),
        toolbarHeight: d.height100 * 0.55,
        title: Center(
          child: Text(
            "الغنام للنقل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: d.fontSize21),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(width: d.width100 * 3, "assets/photos/25%.png"),
          ),
          Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return RefreshIndicator(
              onRefresh: () {
                setState(() {});
                return Future.delayed(Duration.zero);
              },
              child: FutureBuilder(
                  future: dataProvider.getBusListCollectionReference.get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LottieBuilder.asset(
                            height: 60,
                            "assets/lottie/alghannamProgressInd.json"),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data?.size,
                        itemBuilder: ((context, index) {
                          String imageURL =
                              snapshot.data?.docs.elementAt(index)['mainImage'];
                          return InkWell(
                            onTap: () async {
                              dataProvider.clear();
                              dataProvider.setBusId(
                                  snapshot.data!.docs.elementAt(index).id);
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const BusPage()));
                              setState(() {});
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Card(
                                color: Colors.grey[100],
                                elevation: 20,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: d.height20 / 10,
                                      bottom: d.height20 / 10,
                                      right: d.height20 / 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                      width: 1.5,
                                      color: colors.mainYallo,
                                    ),
                                  ),
                                  height: d.height20 * 3.75,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: Text(
                                          snapshot.data!.docs
                                              .elementAt(index)['busName'],
                                          style: TextStyle(
                                              fontSize: d.fontSize18 + 1,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: d.width20,
                                      ),
                                      SizedBox(
                                        height: d.height25 * 3,
                                        width: d.height25 * 3,
                                        child: (imageURL == '')
                                            ? Image.asset(
                                                'assets/photos/1080Asset 5.png')
                                            : Image.network(
                                                imageURL,
                                                errorBuilder:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                height:
                                                    d.height100 - d.height20,
                                                width: d.width100 - d.width20,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  }),
            );
          }),
        ],
      ),
    );
  }
}
