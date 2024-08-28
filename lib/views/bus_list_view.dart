import 'package:alghannam_transport/data/authentication_functions.dart';
import 'package:alghannam_transport/data/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../utils/colors.dart';
import '../utils/dimantions.dart';

class BusListView extends StatefulWidget {
  const BusListView({super.key});

  @override
  State<BusListView> createState() => _BusListViewState();
}

class _BusListViewState extends State<BusListView> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    print("user id is : ${AuthenticationFunctions().getUserId()}");
    var d = Dimantions(s: MediaQuery.of(context).size);
    return Consumer2<ViewProvider, DataProvider>(
      builder: (context, viewProvider, dataProvider, child) {
        try {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh_rounded)),
                      IconButton(
                          onPressed: () {
                            viewProvider.toDefaultLeft();
                            viewProvider.toRightSideList();

                            dataProvider.busId = '';
                          },
                          icon: const Icon(Icons.arrow_forward_ios)),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future:
                            dataProvider.getBusListCollectionReference.get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LottieBuilder.asset(
                                  height: 60,
                                  "assets/lottie/alghannamProgressInd.json"),
                            );
                          } else {
                            print("we are here");
                            return ListView.builder(
                              itemCount: snapshot.data?.size,
                              itemBuilder: ((context, index) {
                                String imageURL = snapshot.data!.docs
                                    .elementAt(index)['mainImage'];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      dataProvider.clear();
                                      viewProvider.toBusPage();
                                      dataProvider.setBusId(snapshot.data!.docs
                                          .elementAt(index)
                                          .id);
                                      selected = index;
                                      if (kDebugMode) {
                                        print(dataProvider.getBusId);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Card(
                                      color: (selected == index)
                                          ? colors.mainYallo3
                                          : Colors.grey[100],
                                      borderOnForeground: !(selected == index),
                                      elevation: selected == index ? 20 : 2,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: d.height20 / 7,
                                            bottom: d.height20 / 7,
                                            right: d.height20 / 5),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                            width: 1.5,
                                            color: colors.mainYallo,
                                          ),
                                        ),
                                        height: d.height20 * 4.25,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Center(
                                              child: Text(
                                                snapshot.data!.docs.elementAt(
                                                    index)['busName'],
                                                style: TextStyle(
                                                    fontSize: d.fontSize18 + 1,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: d.width20,
                                            ),
                                            Container(
                                              height: d.height25 * 3,
                                              width: d.height25 * 3,
                                              child: (imageURL == '')
                                                  ? Image.asset(
                                                      'assets/photos/1080Asset 5.png')
                                                  : Image.network(
                                                      imageURL,
                                                      errorBuilder: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      height: d.height100 -
                                                          d.height20,
                                                      width: d.width100 -
                                                          d.width20,
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
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: d.height20),
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: colors.mainYallo,
                  onPressed: () {
                    selected = -1;
                    viewProvider.toDefaultLeft();
                    viewProvider.toNewBusView();
                  },
                ),
              ),
            ],
          );
        } on FirebaseException catch (e) {
          print(e.code);
          return Center(
            child: Column(
              children: [
                Text("لا يوجد اتصال"),
                IconButton(
                    onPressed: () => setState(() {}), icon: Icon(Icons.refresh))
              ],
            ),
          );
        }
      },
    );
  }
}
