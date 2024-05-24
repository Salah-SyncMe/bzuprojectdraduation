import 'dart:io';
import 'package:bzushadengraduation/view/profile/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../animation/animation.dart';
import '../../controller/provider_file.dart';
import '../../model/api.dart';

class ProfileSubImageAndImage extends StatefulWidget {
  const ProfileSubImageAndImage({super.key});

  @override
  State<ProfileSubImageAndImage> createState() =>
      _ProfileSubImageAndImageState();
}

class _ProfileSubImageAndImageState extends State<ProfileSubImageAndImage> {
  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    CustomFileImage customFileImage = context.watch<CustomFileImage>();

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.39,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height * 0.35,
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.r),
                          child: CachedNetworkImage(
                            imageUrl: api.me?.subImage ?? '',
                            // widget.post.images[0].toString(),

                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[500]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.maxFinite,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              );
                              // CircularProgressIndicator(
                              //    color: Colors.black,
                              // strokeWidth: 0,
                              // value: 30,
                              //
                              //  );
                            },
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 9,
                              shape: const CircleBorder(
                                  side: BorderSide(width: 1)),
                            ),
                            onPressed: () async {
                              await showDialog(
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
                                                width: 5, color: Colors.black),
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
                                                      await customFileImage
                                                          .changeFileCamera();

                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ),
                                                      );

                                                      await api
                                                          .updateSubMyPicture(
                                                              customFileImage
                                                                  .file);
                                                      customFileImage.file =
                                                          File('');
                                                      // Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Take a Camera"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      await customFileImage
                                                          .changeFileGalary();

                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ),
                                                      );

                                                      await api
                                                          .updateSubMyPicture(
                                                              customFileImage
                                                                  .file);
                                                      customFileImage.file =
                                                          File('');
                                                      // Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "Select a Gallary"
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.blue,
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
                                  });

                              await Future.delayed(const Duration(seconds: 6));
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.black, width: 2)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * 0.12,
                          height: MediaQuery.of(context).size.height * 0.12,
                          imageUrl: api.me?.image ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                            color: Colors.black,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                              shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await showDialog(
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
                                            width: 5, color: Colors.black),
                                        borderRadius: BorderRadius.circular(25),
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
                                                  await customFileImage
                                                      .changeFileCamera();

                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                  );

                                                  await api.updateMyPicture(
                                                      customFileImage.file);
                                                  customFileImage.file =
                                                      File('');
                                                  // Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Take a Camera".toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  await customFileImage
                                                      .changeFileGalary();

                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                  );

                                                  await api.updateMyPicture(
                                                      customFileImage.file);
                                                  customFileImage.file =
                                                      File('');
                                                  // Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "Select a Gallary"
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.blue,
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
                                            fontFamily: "Pacifico",
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              });

                          await Future.delayed(const Duration(seconds: 6));
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      api.me?.name ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          height: 1,
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: "Agbalumo"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(api.me?.email ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: "CrimsonText")),
                  )
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  Navigator.push(context, Animations(page: EditProfile()));
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 2,
                              blurRadius: 10,
                              blurStyle: BlurStyle.outer)
                        ],
                        // border: Border.all(color: Colors.black,width: 2),
                        gradient: LinearGradient(colors: [
                          Colors.white,
                          Colors.white54,

                          // Colors.white38,
                        ], transform: GradientRotation(90)),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Agbalumo"),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
