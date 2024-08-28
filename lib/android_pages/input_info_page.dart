import 'dart:io';

import 'package:alghannam_transport/android_pages/inputs_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/providers.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';
import 'package:lottie/lottie.dart';

class InputInfoPage extends StatefulWidget {
  const InputInfoPage({super.key});

  @override
  State<InputInfoPage> createState() => _InputInfoPageState();
}

class _InputInfoPageState extends State<InputInfoPage> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    TextEditingController notes = TextEditingController();
    notes.text = '';

    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: colors.mainYallo2,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: colors.mainYallo,
                      width: 1,
                    )),
                child: IconButton(
                    onPressed: () async {
                      try {
                        final con = await Connectivity().checkConnectivity();
                        final result = await InternetAddress.lookup(
                            'console.firebase.google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty &&
                            !(con == ConnectivityResult.none)) {
                          print('connected');
                          ViewProvider()
                              .androidCustomProgressDialog(context: context);

                          await dataProvider.deleteInput(context: context);

                          Navigator.of(context).pop();
                        } else {
                          print('not connected');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ViewProvider().errorDialog(
                                  "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                  context);
                            },
                          );
                        }
                      } on SocketException catch (_) {
                        print('not connected');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ViewProvider().errorDialog(
                                "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                context);
                          },
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: colors.mainYallo,
                    )),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            SizedBox(width: d.height100 * 0.55),
          ],
          iconTheme:
              IconThemeData(size: d.height25 * 1.25, color: Colors.white),
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
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                width: d.width100 * 3,
                "assets/photos/25%.png",
              ),
            ),
            Container(
              padding: EdgeInsets.all(d.width20),
              alignment: Alignment.center,
              child: FutureBuilder(
                future: dataProvider.getIntputDocumentReference.get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: LottieBuilder.asset(
                          height: 60,
                          "assets/lottie/alghannamProgressInd.json"),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!["Name"].toString(),
                              style: TextStyle(
                                  fontSize: d.fontSize18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "اسم الوارد",
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!["Type"].toString(),
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                            Text(
                              "نوع الوارد",
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!["Value"].toString(),
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                            Text(
                              "القيمة الواردة",
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              format.format(snapshot.data!['Date'].toDate()),
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                            Text(
                              "تاريخ الوارد",
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            notes.text = (snapshot.data?["notes"] == null)
                                ? ''
                                : snapshot.data?["notes"];
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: d.height20 / 4),
                                      child: SingleChildScrollView(
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                icon: const Icon(
                                                    Icons.arrow_forward_ios)),
                                            SizedBox(
                                              height: d.height200 * 3,
                                              child: TextField(
                                                textAlign: TextAlign.end,
                                                controller: notes,
                                                expands: true,
                                                minLines: null,
                                                maxLines: null,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  final result =
                                                      await InternetAddress.lookup(
                                                          'console.firebase.google.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    print('connected');
                                                    await dataProvider
                                                        .getIntputDocumentReference
                                                        .update({
                                                      "notes": notes.text
                                                    });
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  }
                                                } on SocketException catch (_) {
                                                  print('not connected');
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return ViewProvider()
                                                          .errorDialog(
                                                              "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                              context);
                                                    },
                                                  );
                                                }
                                              },
                                              child: const Text("حفظ"),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            );
                          },
                          child: Text(
                            "ملاحظات",
                            style: TextStyle(fontSize: d.fontSize18),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
