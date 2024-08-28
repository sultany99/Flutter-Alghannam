import 'package:alghannam_transport/android_pages/home_page.dart';
import 'package:alghannam_transport/android_pages/signUp_page.dart';
import '/data/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/authentication_functions.dart';
import '../utils/dimantions.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  bool obscureText = true;
  TextEditingController pass = TextEditingController();
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
              child: Image.asset('assets/photos/1080Asset 5.png'),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              textAlign: TextAlign.center,
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
                      obscureText = !obscureText;
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 5),
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
                    "تسجيل دخول",
                    style: TextStyle(fontSize: d.fontSize18),
                  ),
                ),
                onPressed: () async {
                  ViewProvider().androidCustomProgressDialog(context: context);
                  await af.login(email.text, pass.text).then(
                    (value) {
                      if (value == "done") {
                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomePage()));
                        if (kDebugMode) {
                          print('done');
                        }
                      } else {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          builder: (context) {
                            if (value == "user-not-found") {
                              return ViewProvider().errorDialog(
                                  '''البريد الإلكتروني غير موجود''', context);
                            } else if (value == "wrong-password") {
                              return ViewProvider()
                                  .errorDialog("خطأ في كلمة المرور", context);
                            } else {
                              return ViewProvider().errorDialog(value, context);
                            }
                          },
                        );
                      }
                      if (kDebugMode) {
                        print(value);
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
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: Text(
                  "انشاء حساب جديد",
                  style: TextStyle(
                    fontSize: d.fontSize21 * 0.75,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
