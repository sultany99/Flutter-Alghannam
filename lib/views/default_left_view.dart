import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DefaultLeftView extends StatefulWidget {
  DefaultLeftView({super.key});

  @override
  State<DefaultLeftView> createState() => _DefaultLeftViewState();
}

class _DefaultLeftViewState extends State<DefaultLeftView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset('assets/photos/1080Asset 5.png'),
    );
  }
}
