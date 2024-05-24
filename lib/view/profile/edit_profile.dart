import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/api.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? verify;

  bool password = true;

  bool conPassword = true;

  TextEditingController pass = TextEditingController();

  TextEditingController conPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isloading = false;

  bool isloadingphone = false;

  bool visible = true;
  bool isSwitch = false;

  String number = "";

  String pathImage = "";
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      name = TextEditingController(text: context.read<API>().me?.name);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    printLog(name);
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Curves.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
                            "Update",
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: CachedNetworkImage(
                            width: 80.w,
                            height: 80.w,
                            imageUrl: api.me!.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[500]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.maxFinite,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 40, right: 40, top: 20),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: name,
                              // initialValue: api.me?.name ?? '',
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
                              enabled: false,
                              initialValue: api.me?.email,
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontFamily: "fonts/TrajanPro.ttf"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35.0),
                              child: Switch(
                                activeColor: Colors.blue,
                                splashRadius: 7,
                                value: isSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitch = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: !isSwitch ? false : true,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40, top: 20),
                                  child: TextFormField(
                                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: pass,
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
                                                color: Colors.lightBlue,
                                                width: 2),
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
                                        labelText: "New Password",
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        hintText:
                                            "Enter the password should at least 6 character ",
                                        hintStyle: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15),
                                        prefixIcon: const Icon(
                                          Icons.password,
                                          color: Colors.black,
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                                color: Colors.black))),

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
                                    controller: conPass,
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
                                                color: Colors.lightBlue,
                                                width: 2),
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
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        hintText:
                                            "Enter the password should at least 6 character ",
                                        hintStyle: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15),
                                        prefixIcon: const Icon(
                                          Icons.password,
                                          color: Colors.black,
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                                color: Colors.black))),

                                    keyboardType: TextInputType.visiblePassword,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 215.w,
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
                                    if (isSwitch) {
                                      if (conPass.text.toString() ==
                                          (pass.text.toString())) {
                                        setState(() {
                                          isloading = false;
                                        });
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              actionScrollController:
                                                  ScrollController(
                                                      keepScrollOffset: true,
                                                      initialScrollOffset: 10),
                                              title: const Text("Update",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22)),
                                              content: const Text(
                                                  "Are you sure to do Update",
                                                  style: TextStyle(
                                                      fontFamily: 'CrimsonText',
                                                      fontSize: 15,
                                                      color: Colors.black87)),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);

                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      await api
                                                          .updatePassAndName(
                                                              name.text,
                                                              pass.text
                                                                  .toString());

                                                      setState(() {
                                                        isloading = false;
                                                        // value.file = File('');
                                                      });
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Was updated successfully",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.blue,
                                                          textColor:
                                                              Colors.black,
                                                          fontSize: 16.0);
                                                      pass.text = '';
                                                      conPass.text = '';
                                                      setState(() {
                                                        isSwitch = false;
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)))
                                              ],
                                            );
                                          },
                                        );
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
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            actionScrollController:
                                                ScrollController(
                                                    keepScrollOffset: true,
                                                    initialScrollOffset: 10),
                                            title: const Text("Update",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22)),
                                            content: const Text(
                                                "Are you sure to do Update",
                                                style: TextStyle(
                                                    fontFamily: 'CrimsonText',
                                                    fontSize: 15,
                                                    color: Colors.black87)),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);

                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    await api
                                                        .updateName(name.text);

                                                    setState(() {
                                                      isloading = false;
                                                      // value.file = File('');
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Was updated successfully",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        textColor: Colors.black,
                                                        fontSize: 16.0);
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No",
                                                      style: TextStyle(
                                                          color: Colors.black)))
                                            ],
                                          );
                                        },
                                      );
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
                                            Text("Update".toUpperCase(),
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
                                            Icons.update,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            "Update".toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    "fonts/TrajanPro.ttf"),
                                          ),
                                        ],
                                      ))),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
