import 'dart:ffi';
import 'dart:io';

import 'package:alghannam_transport/data/providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../utils/colors.dart';
import '../utils/dimantions.dart';

class BusView extends StatefulWidget {
  const BusView({super.key});

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    return Consumer2<ViewProvider, DataProvider>(
        builder: (context, viewProvider, dataProvider, child) {
      return Expanded(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/photos/25%.png",
              ),
            ),
            FutureBuilder(
                future: dataProvider.getBusListCollectionReference
                    .doc(dataProvider.busId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: LottieBuilder.asset(
                          height: 60,
                          "assets/lottie/alghannamProgressInd.json"),
                    );
                  } else {
                    TextEditingController notes = TextEditingController();
                    notes.text = snapshot.data?["notes"] ?? '';
                    return Padding(
                      padding: EdgeInsets.only(
                          top: d.width20 * 0.75,
                          left: d.width20,
                          right: d.width20,
                          bottom: d.height20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      snapshot.data!["busName"],
                                      style: TextStyle(
                                        fontSize: d.fontSize21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: d.height20 / 2,
                                    ),
                                    Text(
                                      snapshot.data!["busId"],
                                      style: TextStyle(
                                        fontSize: d.fontSize21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: d.height20 / 2,
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        QuerySnapshotForAll<
                                                Map<String, Object?>> i =
                                            await dataProvider
                                                .getBusListCollectionReference
                                                .doc(dataProvider.busId)
                                                .collection("captainInfo")
                                                .get();
                                        dataProvider.setCaptainId =
                                            i.docs.first.id;
                                        viewProvider.toCaptainInfoView();
                                      },
                                      child: Text(
                                        "معلومات السائق",
                                        style: TextStyle(
                                          fontSize: d.fontSize21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: d.height20 / 2),
                                                  width: d.width100 * 0.9,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            d.height200 * 3.2,
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.end,
                                                          controller: notes,
                                                          expands: true,
                                                          minLines: null,
                                                          maxLines: null,
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          dataProvider
                                                              .getBusListCollectionReference
                                                              .doc(dataProvider
                                                                  .busId)
                                                              .update({
                                                            "notes": notes.text
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("حفظ"),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        "ملاحظات",
                                        style: TextStyle(
                                          fontSize: d.fontSize21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: d.width20 * 4,
                                ),
                                InkWell(
                                  onTap: () {
                                    viewProvider.toImageAlbumView(
                                        imageAlbumReference: snapshot.data!.ref
                                            .collection("images"),
                                        folderName: dataProvider.busId,
                                        canBeProfile: true);
                                  },
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.all(d.height20 / 7),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                          width: 1,
                                          color: colors.mainYallo,
                                        ),
                                      ),
                                      height: d.height100 * 2.5,
                                      width: d.width100 * 0.60,
                                      child: Image.network(
                                        snapshot.data!["mainImage"],
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    viewProvider.toInputsView();
                                  },
                                  child: const Text("الواردات")),
                              ElevatedButton(
                                  onPressed: () {
                                    viewProvider.toOutputsView();
                                  },
                                  child: const Text("المدفوعات")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    viewProvider.toFromToGainView(
                                        dataProvider
                                            .getBusListCollectionReference
                                            .doc(dataProvider.busId)
                                            .collection("dailyGain"),
                                        false);
                                  },
                                  child: const Text("الربح من- الى")),
                              ElevatedButton(
                                  onPressed: () {
                                    viewProvider.toMonthlyGainView(
                                        dataProvider
                                            .getBusListCollectionReference
                                            .doc(dataProvider.busId)
                                            .collection("dailyGain"),
                                        false);
                                  },
                                  child: const Text("الربح الشهري")),
                              ElevatedButton(
                                  onPressed: () {
                                    viewProvider.toDailyGainView(
                                        dataProvider
                                            .getBusListCollectionReference
                                            .doc(dataProvider.busId)
                                            .collection("dailyGain"),
                                        false);
                                  },
                                  child: const Text("الربح اليومي")),
                            ],
                          ),
                          Card(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: colors.mainYallo2,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: colors.mainYallo,
                                    width: 1,
                                  )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20),
                                                height: 225,
                                                width: 350,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "!!!تنبيه",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                          color:
                                                              colors.mainYallo),
                                                    ),
                                                    const Text(
                                                      "هل تريد حذف الباص ؟",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      "ملاحظة:عند حذف الباص لن تكون قادر على استرجاع اي من معلوماته و لن يتم ازالة ارباح الباص من الارباح الكلية للمستخدم",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                final con =
                                                                    await Connectivity()
                                                                        .checkConnectivity();
                                                                final result =
                                                                    await InternetAddress
                                                                        .lookup(
                                                                            'console.firebase.google.com');
                                                                if (result
                                                                        .isNotEmpty &&
                                                                    result[0]
                                                                        .rawAddress
                                                                        .isNotEmpty &&
                                                                    !(con ==
                                                                        ConnectivityResult
                                                                            .none)) {
                                                                  await dataProvider
                                                                      .deleteBus(
                                                                          context:
                                                                              context);
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  viewProvider
                                                                      .toBusListView();
                                                                  viewProvider
                                                                      .toDefaultLeft();
                                                                } else {
                                                                  print(
                                                                      'not connected');
                                                                  // ignore: use_build_context_synchronously
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return ViewProvider().errorDialog(
                                                                          "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                          context);
                                                                    },
                                                                  );
                                                                }
                                                              } on SocketException catch (_) {
                                                                print(
                                                                    'not connected');
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return ViewProvider().errorDialog(
                                                                        "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                        context);
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            style: const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                        Colors
                                                                            .red)),
                                                            child: const Text(
                                                                "موافق")),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("رجوع")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        /* */
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: colors.mainYallo,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        TextEditingController
                                            busNameController =
                                            TextEditingController();
                                        TextEditingController busIdController =
                                            TextEditingController();
                                        TextEditingController
                                            captainNameController =
                                            TextEditingController();
                                        TextEditingController
                                            captainNumberController =
                                            TextEditingController();
                                        TextEditingController
                                            captainAdrrController =
                                            TextEditingController();
                                        TextEditingController
                                            captainSalController =
                                            TextEditingController();
                                        var formKey = GlobalKey<FormState>();
                                        Map busData = await dataProvider
                                            .getBusData(context);
                                        busNameController.text =
                                            busData["busName"];
                                        busIdController.text = busData["busId"];
                                        captainNameController.text =
                                            busData["captanName"];
                                        captainAdrrController.text =
                                            busData["captanAddr"];
                                        captainNumberController.text =
                                            busData["captanNumber"];
                                        captainSalController.text = num.parse(
                                                (busData["captainSal"])
                                                    .toString())
                                            .round()
                                            .toString();
                                        // ignore: use_build_context_synchronously
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                color: colors.mainYallo2,
                                                height: double.infinity,
                                                width: d.width100 * 0.9,
                                                child: SingleChildScrollView(
                                                  child: Form(
                                                    key: formKey,
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                        left: d.width20 / 2,
                                                        right: d.width20 / 2,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_forward_ios)),
                                                          const Text(
                                                              "تعديل معلومات الباص"),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                busNameController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  width: d
                                                                      .width100,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "اسم الباص",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                busIdController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: d
                                                                        .width100,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                              hintText:
                                                                  "رقم الباص",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          const Text(
                                                              "معلومات السائق"),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                captainNameController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: d
                                                                        .width100,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                              hintText:
                                                                  "اسم السائق",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                captainNumberController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: d
                                                                        .width100,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                              hintText:
                                                                  "رقم هاتف السائق",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                captainAdrrController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: d
                                                                        .width100,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                              hintText:
                                                                  "عنوان السائق",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'ادخل نص';
                                                              }
                                                              if (!RegExp(
                                                                      r'^[0-9]+$')
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'ادخل ارقام فقط';
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                captainSalController,
                                                            textAlign:
                                                                TextAlign.end,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: d
                                                                        .width100,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                              hintText:
                                                                  "راتب السائق",
                                                              hintStyle: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20 *
                                                                2.5,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                try {
                                                                  final con =
                                                                      await Connectivity()
                                                                          .checkConnectivity();
                                                                  final result =
                                                                      await InternetAddress
                                                                          .lookup(
                                                                              'console.firebase.google.com');
                                                                  if (result
                                                                          .isNotEmpty &&
                                                                      result[0]
                                                                          .rawAddress
                                                                          .isNotEmpty &&
                                                                      !(con ==
                                                                          ConnectivityResult
                                                                              .none)) {
                                                                    viewProvider.customProgressDialog(
                                                                        context:
                                                                            context);
                                                                    await dataProvider
                                                                        .updateBus(
                                                                      context:
                                                                          context,
                                                                      busName:
                                                                          busNameController
                                                                              .text,
                                                                      busID: busIdController
                                                                          .text,
                                                                      captainName:
                                                                          captainNameController
                                                                              .text,
                                                                      captainNumber:
                                                                          captainNumberController
                                                                              .text,
                                                                      captainAddr:
                                                                          captainAdrrController
                                                                              .text,
                                                                      captainSal:
                                                                          double.parse(
                                                                              captainSalController.text),
                                                                    );
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } else {
                                                                    print(
                                                                        'not connected');
                                                                    // ignore: use_build_context_synchronously
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return ViewProvider().errorDialog(
                                                                            "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                            context);
                                                                      },
                                                                    );
                                                                  }
                                                                } on SocketException catch (_) {
                                                                  print(
                                                                      'not connected');
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return ViewProvider().errorDialog(
                                                                          "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                          context);
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                              // ignore: use_build_context_synchronously
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: const [
                                                                Text("حفظ"),
                                                                Icon(
                                                                    Icons.done),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20 *
                                                                2.5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: colors.mainYallo,
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      );
    });
  }
}
