import '/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/authentication_functions.dart';
import '../utils/dimantions.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  bool obscureText = true;

  Widget build(BuildContext context) {
    AuthenticationFunctions af = AuthenticationFunctions();
    var d = Dimantions(s: MediaQuery.of(context).size);
    return Consumer2<ViewProvider, DataProvider>(
      builder: (context, viewProvider, dataProvider, child) {
        return Container(
          margin: EdgeInsets.only(
            left: d.width20 * 0.5,
            right: d.width20 * 0.5,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: d.height100 * 2.75,
                child: Text(
                  textAlign: TextAlign.center,
                  "تسجيل الدخول",
                  style: TextStyle(
                      fontSize: d.fontSize21 * 2,
                      color: colors.mainYallo,
                      fontWeight: FontWeight.bold),
                ),
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
                height: d.height50 * 0.7,
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
                height: d.height50,
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
                    viewProvider.customProgressDialog(context: context);
                    await af.login(email.text, pass.text).then(
                      (value) {
                        if (value == "done") {
                          dataProvider.email = email.text;
                          dataProvider.userId =
                              AuthenticationFunctions().getUserId();
                          Navigator.of(context).pop();

                          viewProvider.toRightSideList();
                          if (kDebugMode) {
                            print('done');
                          }
                        } else {
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (context) {
                              if (value == "invalid-email") {
                                return viewProvider.errorDialog(
                                    '''البريد الإلكتروني غير موجود''', context);
                              } else if (value == "wrong-password") {
                                return viewProvider.errorDialog(
                                    "خطأ في كلمة المرور", context);
                              } else {
                                return viewProvider.errorDialog(value, context);
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
                    viewProvider.toSignUp();
                  },
                  child: Text(
                    "انشاء حساب جديد",
                    style: TextStyle(
                      fontSize: d.fontSize21 * 0.75,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}

//_______________________________________________________________________________________________
//*********************************************************************************************** */
//_______________________________________________________________________________________________
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  var obscureText = true;
  Widget build(BuildContext context) {
    AuthenticationFunctions af = AuthenticationFunctions();

    final formKey = GlobalKey<FormState>();

    var d = Dimantions(s: MediaQuery.of(context).size);
    return Consumer2<ViewProvider, DataProvider>(
        builder: (context, viewProvider, dataProvider, child) {
      return Container(
        margin: EdgeInsets.only(
          left: d.width20 * 0.5,
          right: d.width20 * 0.5,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: d.height100 * 2.75,
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
                height: d.height50 * 0.7,
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
                height: d.height50,
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
                    viewProvider.customProgressDialog(context: context);
                    await af.creatAccount(email.text, pass.text).then(
                      (value) {
                        Navigator.of(context).pop();
                        if (value == "done") {
                          viewProvider.toSignIn();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return viewProvider.errorDialog(value, context);
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
                    viewProvider.toSignIn();
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
    });
  }
}
