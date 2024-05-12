import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controller/page_controller.dart';
import '../controller/provider_file.dart';
import '../model/api.dart';
import '../utilities/tools.dart';

class CreatePage extends StatefulWidget {
  final API api;

  const CreatePage({super.key, required this.api});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? verify;

  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool visible = true;
  String number = "";
  String pathImage = "";

  @override
  void initState() {
    pathImage = "";
    // context.watch<CustomFileImage>().file = File("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageControllers page = context.watch<PageControllers>();

    CustomFileImage value = context.watch<CustomFileImage>();

    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                border: Border.all(color: Colors.black, width: 2),
                image: const DecorationImage(
                    image: AssetImage("images/Curves.jpg"), fit: BoxFit.fill)),
            child: SafeArea(
                child: Form(
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
                                Center(
                                  child: Text(
                                    "Create page",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 40.sp,
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
                                            backgroundImage:
                                                FileImage(value.file2()),
                                            radius: 50,
                                          )
                                        : Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            52),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2)),
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
                                                            alignment: Alignment
                                                                .center,
                                                            child: AlertDialog(
                                                              elevation: 19,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              shadowColor:
                                                                  Colors.red,
                                                              shape:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    width: 5,
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
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
                                                                          setState(
                                                                              () {
                                                                            page.pathImage =
                                                                                value.file;
                                                                          });
                                                                          setState(
                                                                              () {});
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Take a Camera"
                                                                              .toUpperCase(),
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.blue,
                                                                              fontWeight: FontWeight.bold),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await value
                                                                              .changeFileGalary();
                                                                          setState(
                                                                              () {
                                                                            page.pathImage =
                                                                                value.file;
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
                                                                                fontSize: 17,
                                                                                color: Colors.blue,
                                                                                fontWeight: FontWeight.bold)))
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [],
                                                              title: const Text(
                                                                "Choose the Picture",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        23,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        "Pacifico",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 5,
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
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
                                                                setState(() {});
                                                                await value
                                                                    .changeFileCamera();
                                                                setState(() {
                                                                  page.pathImage =
                                                                      value
                                                                          .file;
                                                                });
                                                                setState(() {});
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
                                                                setState(() {});
                                                                await value
                                                                    .changeFileGalary();
                                                                setState(() {
                                                                  page.pathImage =
                                                                      value
                                                                          .file;
                                                                });
                                                                setState(() {});
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
                                                                          FontWeight
                                                                              .bold)))
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [],
                                                    title: const Text(
                                                      "Choose the Picture",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "Pacifico",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                        icon: (value.file.path != "")
                                            ? Icon(Icons.add_a_photo,
                                                size: 24.w)
                                            : const SizedBox(),
                                        color: Colors.black)
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 40, right: 40, top: 20),
                                    child: TextFormField(
                                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: page.name,

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
                                          labelText: "Name Page",
                                          labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          prefixIcon: Icon(
                                            Icons.drive_file_rename_outline,
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lightBlue,
                                                  width: 2),
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
                                            isLoading = true;
                                          });

                                          if (_formKey.currentState!
                                              .validate()) {
                                            printLog(pathImage);

                                            await page.createPage(context);

                                            setState(() {
                                              isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        child: isLoading
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                    const CircularProgressIndicator(
                                                        color: Colors
                                                            .lightBlueAccent,
                                                        strokeWidth: 1),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text("Create".toUpperCase(),
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
                                                    Icons.create_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    "Create".toUpperCase(),
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
                    )))));
  }
}
