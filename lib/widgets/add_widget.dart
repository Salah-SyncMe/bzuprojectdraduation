import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';
import 'flutter_toast.dart';

class CustomAdd extends StatefulWidget {
  const CustomAdd({super.key});

  @override
  State<CustomAdd> createState() => _CustomAddState();
}

class _CustomAddState extends State<CustomAdd> {
  List<PageUser> list = [];

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String image = message.data['image'];
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 3,
            channelKey: "call_channel",
            title: title,
            displayOnBackground: true,
            displayOnForeground: true,
            body: body,
            color: Colors.green,
            category: NotificationCategory.Service,
            wakeUpScreen: true,
            fullScreenIntent: true,
            backgroundColor: Colors.orange,
            autoDismissible: false,
            largeIcon: image,
            roundedLargeIcon: true,
          ),
          actionButtons: [
            NotificationActionButton(
                key: "Accept",
                label: "Add friend",
                color: Colors.blue,
                autoDismissible: true),
            NotificationActionButton(
                key: "DISMISS",
                label: "Dismiss",
                color: Colors.black54,
                autoDismissible: true),
          ]);
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyPressed == "DISMISS") {
      //     // print("DISMISS");
      //   } else if (event.buttonKeyPressed == "Accept") {
      //     // print("Accept");
      //   }
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pages',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.lightBlue)
                          ],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Agbalumo")),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      alignment: Alignment.center,
                    ),
                    child:
                        const Icon(Icons.search, color: Colors.black, size: 30),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<API>(
                builder: (context, ref, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: FutureBuilder(
                      future: ref.getAllPages(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.3),
                            child: const CustomErrorWidget(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return const CardShimmer();
                            },
                          );
                        } else {
                          final d = snapshot.data;
                          printLog(d?.length);
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: d?.length,
                              itemBuilder: (context, index) {
                                return card(d![index], index);
                              });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget card(PageUser user, int values) {
    API api = context.watch<API>();

    return SizedBox(
        child: Card(
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: CachedNetworkImage(
                width: 60.w,
                height: 60.w,
                imageUrl: user.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[100]!,
                  child: Expanded(
                    child: Container(
                      width: double.maxFinite,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 155.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                color: Colors.black,
                                fontFamily: "Agbalumo")),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(user.adminName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontFamily: "CrimsonText")),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
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
                                  Colors.blue,
                                  Colors.black,

                                  // Colors.white38,
                                ], transform: GradientRotation(90)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "  Follow  ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Agbalumo"),
                                )
                              ],
                            )),
                        onTap: () async {
                          if (await api.addPage(user.id) == true) {
                          } else {
                            flutterToast("");
                          }
                        },
                      ),
                      // SizedBox(
                      //   width: 10.w,
                      // ),
                      // InkWell(
                      //   onTap: () async {
                      //     await api.addFriend(user.email).then((value) {
                      //       if (!value) {
                      //         Fluttertoast.showToast(
                      //             msg: 'User not join the app',
                      //             fontSize: 20,
                      //             toastLength: Toast.LENGTH_LONG);
                      //       } else {
                      //         Fluttertoast.showToast(
                      //             msg: 'Was Added successfully',
                      //             fontSize: 20,
                      //             toastLength: Toast.LENGTH_LONG);
                      //       }
                      //     });
                      //     //show notification
                      //     // await NotificationService.showNotification(title: user.name, body: user.email);
                      //
                      //     //show notification with summary
                      //     //  await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                      //     //  notificationLayout: NotificationLayout.Inbox);
                      //
                      //     // Notification progress Bar
                      //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                      //     //     notificationLayout: NotificationLayout.ProgressBar);
                      //
                      //     //Notification Message Notification
                      //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                      //     //     notificationLayout: NotificationLayout.Messaging);
                      //
                      //     //Notification big image
                      //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                      //     //     notificationLayout: NotificationLayout.BigPicture,bigPicture: user.image);
                      //
                      //     //notification button
                      //     // await NotificationService.showNotification(
                      //     //
                      //     //     title: user.name,
                      //     //     body: user.email,
                      //     //     summry: "Small summary",
                      //     //     actionButtons: [
                      //     //       NotificationActionButton(
                      //     //           key: "Accept",
                      //     //           label: "Add friend",
                      //     //           color: Colors.blue,
                      //     //           autoDismissible: true),
                      //     //       NotificationActionButton(
                      //     //           key: "DISMISS",
                      //     //           label: "Dismiss",
                      //     //           color: Colors.black54,
                      //     //           autoDismissible: true),
                      //     //     ]);
                      //
                      //     // //show buttons with summary
                      //     // await NotificationService.showNotification(
                      //     //     summry: "Small summary",
                      //     //         notificationLayout: NotificationLayout.Messaging,
                      //     //     title: user.name,
                      //     //     body: user.email,
                      //     //     actionButtons: [
                      //     //       NotificationActionButton(
                      //     //           key: "Accept",
                      //     //           label: "Add friend",
                      //     //           color: Colors.blue,
                      //     //           autoDismissible: true),
                      //     //       NotificationActionButton(
                      //     //           key: "DISMISS",
                      //     //           label: "Dismiss",
                      //     //           color: Colors.black54,
                      //     //           autoDismissible: true),
                      //     //     ]);
                      //
                      //     //show notification Schadule waiting 5 seconds
                      //
                      //     await api.sendNotificationPage(user);
                      //     // await NotificationService.showNotification(
                      //     //     summry: "Small summary",
                      //     //     notificationLayout:
                      //     //         NotificationLayout.Default,
                      //     //     title: user.name,
                      //     //     body: user.email,
                      //     //
                      //     //
                      //     //
                      //     //     actionType: ActionType.KeepOnTop,
                      //     //     imageProfile: user.image,
                      //     //     actionButtons: [
                      //     //       NotificationActionButton(
                      //     //           key: "Accept",
                      //     //           label: "Add friend",
                      //     //           color: Colors.blue,
                      //     //           autoDismissible: true),
                      //     //       NotificationActionButton(
                      //     //           key: "DISMISS",
                      //     //           label: "Dismiss",
                      //     //           color: Colors.black54,
                      //     //           autoDismissible: true),
                      //     //     ]);
                      //   },
                      //   child: Container(
                      //       padding: const EdgeInsets.all(10),
                      //       decoration: const BoxDecoration(
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Colors.black,
                      //                 spreadRadius: 2,
                      //                 blurRadius: 10,
                      //                 blurStyle: BlurStyle.outer)
                      //           ],
                      //           // border: Border.all(color: Colors.black,width: 2),
                      //           gradient: LinearGradient(colors: [
                      //             Colors.white,
                      //             Colors.white54,
                      //
                      //             // Colors.white38,
                      //           ], transform: GradientRotation(90)),
                      //           borderRadius:
                      //           BorderRadius.all(Radius.circular(20))),
                      //       child: const Row(
                      //         children: [
                      //           Icon(
                      //             Icons.person_remove_outlined,
                      //             color: Colors.black,
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Text(
                      //             "  Remove  ",
                      //             style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontFamily: "Agbalumo"),
                      //           )
                      //         ],
                      //       )),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
