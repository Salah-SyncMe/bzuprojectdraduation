import 'dart:async';
import 'package:bzushadengraduation/controller/login_controller.dart';
import 'package:bzushadengraduation/view/register.dart';
import 'package:bzushadengraduation/widgets/flutter_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:regexpattern/regexpattern.dart';
import '../animation/animation.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool password = true;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool visible = true;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    checkActivity();
    super.initState();
  }

  checkActivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result.isEmpty) {
      isDeviceConnected = false;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    }
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginController = context.watch<LoginController>();
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Curves.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Form(
            key: _formKey,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 55,
                              color: Colors.black,
                              fontFamily: "Pacifico"),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width >= 600
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 20),
                          child: TextFormField(
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: loginController.email,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'fill the email';
                              } else if ((value
                                      .toString()
                                      .trim()
                                      .contains("@student.birzeit.edu") ==
                                  false)) {
                                return 'Error: you should email end student.birzeit.edu';
                              } else if ((value.toString().trim().isEmail()) ==
                                  false) {
                                return ' The email is not correct';
                              }
                              return null;
                            },
                            cursorColor: Colors.black,

                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            decoration: const InputDecoration(
                                // filled: true,
                                // fillColor: Colors.transparent,

                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                hintStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),

                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 20),
                          width: MediaQuery.of(context).size.width >= 600
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width * 0.8,
                          color: Colors.transparent,
                          child: TextFormField(
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: loginController.password,
                            obscureText: password,
                            cursorColor: Colors.black,

                            validator: (value) {
                              if (value.toString().isEmpty &&
                                  value.toString().length < 6) {
                                return 'Fill the password and You should the password at least 6 characters';
                              } else if (value.toString().isEmpty) {
                                return 'Fill the password';
                              } else if (value.toString().length < 6) {
                                return 'You should the password at least 6 characters';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      //
                                      password = !password;
                                      //
                                    });
                                  },
                                  icon: Icon(
                                    (password == true
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    color: Colors.black,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                hintText:
                                    "Enter the password should at least 6 character ",
                                hintStyle: const TextStyle(
                                    color: Colors.black45, fontSize: 15),
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 2))),

                            keyboardType: TextInputType.visiblePassword,
                          )),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width >= 600
                            ? MediaQuery.of(context).size.width * 0.5
                            : MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width >= 600
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width * 0.7,
                          height: 50,
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 2,
                                    blurRadius: 30,
                                    blurStyle: BlurStyle.outer)
                              ],
                              // border: Border.all(color: Colors.black,width: 2),
                              gradient: LinearGradient(colors: [
                                Colors.blueAccent,
                                Colors.black,

                                // Colors.white38,
                              ], transform: GradientRotation(90)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                setState(() async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (await loginController
                                            .loginWithEmail(context) ==
                                        true) {
                                      // await fetchData();
                                      // value.changelist(h);
                                      // print(value.h);
                                      Navigator.of(context).pushReplacement(
                                          Animations(page: const Home()));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                        flutterToast(
                                            'Error: email or password not correct');
                                      });
                                    }
                                  } else {
                                    isLoading = false;
                                  }
                                });
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text("LOGIN".toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      "fonts/TrajanPro.ttf"))
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.login,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "LOGIN".toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily:
                                                  "fonts/TrajanPro.ttf"),
                                        ),
                                      ],
                                    ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "fonts/TrajanPro.ttf")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(Animations(page: const Register()));
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blueAccent),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            actionScrollController: ScrollController(
                keepScrollOffset: true, initialScrollOffset: 10),
            title: const Text("No Connection",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text(
              "Please Check your internet Connectivity",
              style: TextStyle(
                  fontFamily: 'CrimsonText',
                  fontSize: 15,
                  color: Colors.black87),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() {
                        isAlertSet = true;
                      });
                    }
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );
}
