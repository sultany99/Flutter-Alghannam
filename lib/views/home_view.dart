import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:alghannam_transport/utils/dimantions.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    bool isMaximized = false;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(33),
        child: MoveWindow(
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(color: Colors.orange[300]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 90,
                  padding: const EdgeInsets.only(left: 2.0, top: 2),
                  child: Image.asset('assets/photos/1080Asset 5.png'),
                ),
                const Text(
                  "الغنام للنقل",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.mainYallo),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        windowManager.minimize();
                      },
                      icon: const Icon(Icons.minimize_outlined,
                          size: 20, color: colors.mainGray),
                    ),
                    IconButton(
                      onPressed: () {
                        if (isMaximized) {
                          windowManager.restore();

                          isMaximized = false;
                        } else {
                          isMaximized = true;
                          windowManager.maximize();
                        }
                      },
                      icon: const Icon(Icons.crop_square,
                          size: 20, color: colors.mainGray),
                    ),
                    IconButton(
                      onPressed: () {
                        windowManager.close();
                      },
                      icon: const Icon(Icons.close,
                          size: 20, color: colors.mainGray),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Consumer<ViewProvider>(
        builder: (context, viewProvider, child) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                viewProvider.homeLeftSide,
                Container(
                  color: colors.mainYallo2,
                  width: d.width100 * 0.9,
                  child: viewProvider.homeRightSide,
                ),
              ]);
        },
      ),
    );
  }
}
