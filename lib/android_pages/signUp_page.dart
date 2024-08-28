import 'package:alghannam_transport/android_pages/signIn_page.dart';
import '/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:flutter/material.dart';
import '../data/authentication_functions.dart';
import '../utils/dimantions.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    AuthenticationFunctions af = AuthenticationFunctions();
    var d = Dimantions(s: MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: d.width20,
          right: d.width20,
        ),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              alignment: Alignment.center,
              height: d.height200 * 1.5,
              child: Text(
                textAlign: TextAlign.center,
                "انشاء حساب جديد",
                style: TextStyle(
                    fontSize: d.fontSize21 * 2,
                    color: colors.mainYallo,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    ),
                  ),
                  label: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                        fontSize: d.fontSize18,
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: d.height50,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: pass,
              obscureText: obscureText,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: d.width20),
                  ),
                  label: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      "كلمة المرور",
                      style: TextStyle(fontSize: d.fontSize18),
                    ),
                  )),
            ),
            SizedBox(
              height: d.height100 * 0.8,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "انشاء الحساب",
                    style: TextStyle(fontSize: d.fontSize18),
                  ),
                ),
                onPressed: () async {
                  ViewProvider().androidCustomProgressDialog(context: context);
                  await af.creatAccount(email.text, pass.text).then(
                    (value) {
                      Navigator.of(context).pop();
                      if (value == "done") {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignIn()));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ViewProvider().errorDialog(value, context);
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: d.height20 * 3,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
                child: Text(
                  'رجوع',
                  style: TextStyle(
                    fontSize: d.fontSize18,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
