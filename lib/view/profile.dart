import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/post.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Post> list = [];

  @override
  Widget build(BuildContext context) {
    list.add(Post(
        images: [],
        imageUrl: "",
        name: "",
        createAt: "",
        text: "",
        id: "",
        email: ""));
    return Consumer<API>(
      builder: (context, value, child) => StreamBuilder(
        stream: value.getAllMyPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              child: const CustomErrorWidget(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const CardShimmer();
              },
            );
          } else {
            final d = snapshot.data?.docs;
            list.addAll(d!.map((e) => Post.fromJson(e.data())).toList());

            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return index == 0
                      ? profile()
                      : (list[index].images.isEmpty
                          ? card(list[index])
                          : cardWithPicture(
                              list[index], list[index].images[0]));
                });
          }
        },
      ),
    );
  }

  Widget profile() {
    API api = context.watch<API>();

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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.black, width: 1),
                            image: const DecorationImage(
                                image: AssetImage("images/pic.jpg"),
                                fit: BoxFit.fill)),
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
                            onPressed: () async {},
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
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 9,
                          shape: const CircleBorder(side: BorderSide(width: 1)),
                        ),
                        onPressed: () async {},
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        )),
                  )
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

  styleItems() {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        height: 1,
        fontSize: 20,
        color: Colors.black,
        fontFamily: "VarelaRound");
  }

  Widget card(Post post) {
    API api = context.watch<API>();

    return Card(
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: AssetImage("images/Curves.png"),
                    //   radius: 20,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: CachedNetworkImage(
                        width: 40.w,
                        height: 40.w,
                        imageUrl: post.imageUrl,
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

                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(post.name.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Agbalumo")),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(post.email.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: "CrimsonText")),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                actionScrollController: ScrollController(
                                    keepScrollOffset: true,
                                    initialScrollOffset: 10),
                                title: const Text("Delete Post",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                                content: const Text(
                                    "Are you sure to Delete post",
                                    style: TextStyle(
                                        fontFamily: 'CrimsonText',
                                        fontSize: 15,
                                        color: Colors.black87)),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await api.deletePost(post);

                                        Fluttertoast.showToast(
                                            msg:
                                                "Was Delete post to ${api.me?.name ?? ''}",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      },
                                      child: const Text("Yes")),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"))
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.cancel)),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: double.maxFinite,
              padding: const EdgeInsets.all(0),
              child: Text(post.text.toString().trim(),
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.greenAccent)
                      ],
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "CrimsonText")),
            ),
            const Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "like",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "comment",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "share",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget cardWithPicture(Post post, String image) {
    API api = context.watch<API>();

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Card(
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage: AssetImage("images/Curves.png"),
                        //   radius: 20,
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(95.r),
                          child: CachedNetworkImage(
                            width: 50.w,
                            height: 50.w,
                            imageUrl: post.imageUrl,
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

                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(post.name.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: "Agbalumo")),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(post.email.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "CrimsonText")),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    actionScrollController: ScrollController(
                                        keepScrollOffset: true,
                                        initialScrollOffset: 10),
                                    title: const Text("Delete Post",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                    content: const Text(
                                        "Are you sure to Delete post",
                                        style: TextStyle(
                                            fontFamily: 'CrimsonText',
                                            fontSize: 15,
                                            color: Colors.black87)),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            await api.deletePost(post);

                                            Fluttertoast.showToast(
                                                msg:
                                                    "Was Delete post to ${api.me?.name}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.black,
                                                fontSize: 16.0);
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No"))
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.cancel)),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(0),
                  child: Text(post.text.toString().trim(),
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.greenAccent)
                          ],
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "CrimsonText")),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: image,
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
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "like",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "comment",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "share",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
