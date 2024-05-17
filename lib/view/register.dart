import 'dart:io';

import 'package:bzushadengraduation/controller/provider_file.dart';
import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controller/registeration_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with AutomaticKeepAliveClientMixin<Register> {
  String? verify;

  bool password = true;
  bool conPassword = true;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isloading = false;
  bool isloadingphone = false;
  bool visible = true;
  String number = "";
  String pathImage = "";

  @override
  void initState() {
    pathImage = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterController register = context.watch<RegisterController>();
    CustomFileImage value = context.watch<CustomFileImage>();
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Curves.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Form(
            key: _formKey,
            child: SafeArea(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "Register",
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
                        Stack(
                          alignment: const FractionalOffset(1.2, 1.2),
                          children: [
                            (value.file.path != "")
                                ? CircleAvatar(
                                    backgroundImage: FileImage(value.file2()),
                                    radius: 50,
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            border: Border.all(
                                                color: Colors.black, width: 2)),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              FileImage(value.file2()),
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    alignment: Alignment.center,
                                                    child: AlertDialog(
                                                      elevation: 19,
                                                      alignment:
                                                          Alignment.center,
                                                      shadowColor: Colors.red,
                                                      shape: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 5,
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      content: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .shortestSide *
                                                            0.4,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await value
                                                                      .changeFileCamera();
                                                                  setState(() {
                                                                    register.pathImage =
                                                                        value
                                                                            .file;
                                                                  });
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  "Take a Camera"
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await value
                                                                      .changeFileGalary();
                                                                  setState(() {
                                                                    register.pathImage =
                                                                        value
                                                                            .file;
                                                                  });
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Select a Gallary"
                                                                        .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.bold)))
                                                          ],
                                                        ),
                                                      ),
                                                      title: const Text(
                                                        "Choose the Picture",
                                                        style: TextStyle(
                                                            fontSize: 23,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "Pacifico",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ));
                                              },
                                            );
                                          },
                                          child: Icon(Icons.add_a_photo,
                                              size: 24.w)),
                                    ],
                                  ),
                            IconButton(
                                splashRadius: 100,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                          alignment: Alignment.center,
                                          child: AlertDialog(
                                            elevation: 19,
                                            alignment: Alignment.center,
                                            shadowColor: Colors.red,
                                            shape: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 5,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            content: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .shortestSide *
                                                  0.4,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        setState(() {});
                                                        await value
                                                            .changeFileCamera();
                                                        setState(() {
                                                          register.pathImage =
                                                              value.file;
                                                        });
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Take a Camera"
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                      onPressed: () async {
                                                        setState(() {});
                                                        await value
                                                            .changeFileGalary();
                                                        setState(() {
                                                          register.pathImage =
                                                              value.file;
                                                        });
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          "Select a Gallary"
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))
                                                ],
                                              ),
                                            ),
                                            title: const Text(
                                              "Choose the Picture",
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.black,
                                                  fontFamily: "Pacifico",
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                    },
                                  );
                                },
                                icon: (value.file.path != "")
                                    ? Icon(Icons.add_a_photo, size: 24.w)
                                    : const SizedBox(),
                                color: Colors.black)
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 20),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: register.name,

                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'fill the name';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  hintStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.person,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 20),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: register.email,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'fill the email';
                                } else if ((value
                                        .toString()
                                        .trim()
                                        .contains("@student.birzeit.edu") ==
                                    false)) {
                                  return 'Error: you should email end student.birzeit.edu';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),

                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 20),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: register.password,
                              obscureText: password,

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
                                  fillColor: Colors.transparent,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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
                                  labelText: "Password",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
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
                                          BorderSide(color: Colors.black))),

                              keyboardType: TextInputType.visiblePassword,
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 20),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: register.coPassword,
                              obscureText: conPassword,

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
                                  fillColor: Colors.transparent,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        //
                                        conPassword = !conPassword;
                                        //
                                      });
                                    },
                                    icon: Icon(
                                      (conPassword == true
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: Colors.black,
                                    ),
                                  ),
                                  filled: true,
                                  labelText: "Confirm Password",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
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
                                          BorderSide(color: Colors.black))),

                              keyboardType: TextInputType.visiblePassword,
                            )),
                        const SizedBox(
                          height: 22,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 340,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                gradient: const LinearGradient(colors: [
                                  Colors.blueAccent,
                                  Colors.black,
                                ], transform: GradientRotation(90)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                onPressed: () async {
                                  setState(() {
                                    isloading = true;
                                  });

                                  if (_formKey.currentState!.validate()) {
                                    if (register.coPassword.text.toString() ==
                                        (register.password.text.toString())) {
                                      printLog(pathImage);

                                      await register.registerWithEmail(context);

                                      setState(() {
                                        isloading = false;
                                        value.file = File('');
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Thr password not match",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                      setState(() {
                                        isloading = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                },
                                child: isloading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            const CircularProgressIndicator(
                                                color: Colors.lightBlueAccent,
                                                strokeWidth: 1),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Text("Sign up".toUpperCase(),
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
                                            "Sign up".toUpperCase(),
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
                          children: [
                            const Text("Have an account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontFamily: "fonts/TrajanPro.ttf")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.black),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
