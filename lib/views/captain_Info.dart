import 'package:alghannam_transport/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../utils/dimantions.dart';

class CaptainInfo extends StatefulWidget {
  const CaptainInfo({super.key});

  @override
  State<CaptainInfo> createState() => _CaptainInfoState();
}

class _CaptainInfoState extends State<CaptainInfo> {
  DateTime date = DateUtils.dateOnly(
      DateTime(DateTime.now().year, DateTime.now().month, 1));
  double captainSal = 0;
  double payed = 0;
  double remain = 0;
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat("M/y");

    return Expanded(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/photos/25%.png",
            ),
          ),
          Consumer2<ViewProvider, DataProvider>(
            builder: (context, viewProvider, dataProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      viewProvider.toBusPage();
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: dataProvider.getBusListCollectionReference
                          .doc(dataProvider.busId)
                          .collection("captainInfo")
                          .doc(dataProvider.captainId)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: LottieBuilder.asset(
                                height: 60,
                                "assets/lottie/alghannamProgressInd.json"),
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(
                                height: d.height50,
                              ),
                              Text(
                                "معلومات السائق",
                                style: TextStyle(
                                    fontSize: d.fontSize21 * 1.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: d.height100,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!["captainName"],
                                        style: TextStyle(
                                          fontSize: d.fontSize18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      Text(
                                        snapshot.data!["captainNumber"],
                                        style: TextStyle(
                                          fontSize: d.fontSize18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      Text(
                                        snapshot.data!["captainAddr"],
                                        style: TextStyle(
                                          fontSize: d.fontSize18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "اسم السائق",
                                        style:
                                            TextStyle(fontSize: d.fontSize18),
                                      ),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      Text(
                                        "رقم هاتف لسائق",
                                        style:
                                            TextStyle(fontSize: d.fontSize18),
                                      ),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      Text(
                                        "عنوان السائق",
                                        style:
                                            TextStyle(fontSize: d.fontSize18),
                                      ),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            viewProvider.toImageAlbumView(
                                                imageAlbumReference: snapshot
                                                    .data!.ref
                                                    .collection("images"),
                                                folderName:
                                                    '${dataProvider.busId}/${dataProvider.captainId}',
                                                canBeProfile: false);
                                          },
                                          child: Text(
                                            'مستندات السائق',
                                            style: TextStyle(
                                                fontSize: d.fontSize18),
                                          )),
                                      SizedBox(
                                        height: d.height50,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            String dateText = "اختر التاريخ";
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState1) {
                                                  return Dialog(
                                                    child: Container(
                                                      width: d.width100 * 0.9,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_forward_ios),
                                                          ),
                                                          SizedBox(
                                                            height: d.height20,
                                                          ),
                                                          Text("كاش",
                                                              style: TextStyle(
                                                                  fontSize: d
                                                                      .fontSize21)),
                                                          SizedBox(
                                                            height: d.height100,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                      captainSal
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  Text(
                                                                      payed
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  Text(
                                                                      remain
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        showMonthYearPicker(
                                                                                context: context,
                                                                                initialDate: date,
                                                                                firstDate: DateTime(2022, 01, 01),
                                                                                lastDate: DateTime(2050, 01, 01))
                                                                            .then((value) {
                                                                          if (value !=
                                                                              null) {
                                                                            date =
                                                                                value;
                                                                            dateText =
                                                                                format.format(value);
                                                                          }

                                                                          setState1(
                                                                              () {});
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          dateText,
                                                                          style:
                                                                              TextStyle(fontSize: d.fontSize18)))
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    "راتب السائق",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            d.fontSize18),
                                                                  ),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  Text(
                                                                      "المدفوع",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  Text(
                                                                      "المتبقي",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                  SizedBox(
                                                                    height: d
                                                                        .height20,
                                                                  ),
                                                                  Text("الشهر",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              d.fontSize18)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: d.height100,
                                                          ),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                captainSal = snapshot
                                                                        .data![
                                                                    "captainSal"];
                                                                try {
                                                                  await dataProvider
                                                                      .getBusListCollectionReference
                                                                      .doc(dataProvider
                                                                          .busId)
                                                                      .collection(
                                                                          "captainPays")
                                                                      .doc(snapshot
                                                                              .data![
                                                                          "captainName"])
                                                                      .collection(
                                                                          "monthly")
                                                                      .doc(date
                                                                          .toString())
                                                                      .get()
                                                                      .then(
                                                                          (val) {
                                                                    if (val
                                                                        .exists) if (val[
                                                                            "value"] !=
                                                                        null) {
                                                                      payed = val[
                                                                          "value"];
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                                remain =
                                                                    captainSal -
                                                                        payed;
                                                                setState1(
                                                                    () {});
                                                              },
                                                              child: Text(
                                                                  "حساب",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          d.fontSize21))),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Text('كاش')),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
