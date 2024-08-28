import 'package:alghannam_transport/android_pages/new_output_page.dart';
import 'package:alghannam_transport/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_for_all/firebase_for_all.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';
import 'output_info_page.dart';

class OutputsPage extends StatefulWidget {
  const OutputsPage({super.key});

  @override
  State<OutputsPage> createState() => _OutputsPageState();
}

class _OutputsPageState extends State<OutputsPage> {
  DateTime date = DateTime.now();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    TextEditingController notes = TextEditingController();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NewOutputPage()));
        },
        backgroundColor: colors.mainYallo,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          SizedBox(width: d.height100 * 0.55),
        ],
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
            child: Image.asset(
              width: d.width100 * 3,
              "assets/photos/25%.png",
            ),
          ),
          RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Future.delayed(Duration.zero);
            },
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                var outputViewsCol = dataProvider.getBusListCollectionReference
                    .doc(dataProvider.busId)
                    .collection('outputs');
                print(dataProvider.outputId);
                return FutureBuilder(
                  future: outputViewsCol.get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LottieBuilder.asset(
                            height: 60,
                            "assets/lottie/alghannamProgressInd.json"),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () async {
                              await dataProvider.setOutputId(
                                  snapshot.data!.docs.elementAt(index).id);
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => OutputInfoPage()));

                              setState(() {});
                            },
                            child: Card(
                              color: Colors.grey[100],
                              elevation: 20,
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: d.height20 / 10,
                                    bottom: d.height20 / 10,
                                    right: d.width20,
                                    left: d.width20),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    width: 1,
                                    color: colors.mainYallo,
                                  ),
                                ),
                                height: d.height20 * 3.75,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      height: 40,
                                      width: d.width100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                          color: colors.mainYallo,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        snapshot.data!.docs
                                            .elementAt(index)['Value']
                                            .toString(),
                                        style:
                                            TextStyle(color: colors.mainBlack),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs
                                          .elementAt(index)['Name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: d.fontSize18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
