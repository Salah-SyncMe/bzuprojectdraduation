import 'package:bzushadengraduation/view/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../animation/animation.dart';
import '../model/api.dart';
import '../model/post.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';
import 'create_post.dart';

class HomeShow extends StatefulWidget {
  const HomeShow({super.key});

  @override
  State<HomeShow> createState() => _HomeShowState();
}

class _HomeShowState extends State<HomeShow> {
  List<Post> list = [];
  List<Post> list1 = [];

  int index1 = 1;
  int counter = 0;
  bool isUploading = false;

//   API().getAllMyPosts();
// API().getAllPostUsers();

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    width: 50.w,
                    height: 50.w,
                    imageUrl: "${api.me?.image}",
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
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    onTap: () {
                      Navigator.push(
                          context, Animations(page: const CreatePost()));
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        hintText: "What's on your mind?",
                        contentPadding: const EdgeInsets.all(10),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1))),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Posts",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  shadows: [Shadow(blurRadius: 10, color: Colors.lightBlue)],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Agbalumo")),

          Consumer<API>(
            builder: (context, value, child) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder(
                stream: value.getAllMyPosts(),
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
                    final d = snapshot.data?.docs;
                    list = d!.map((e) => Post.fromJson(e.data())).toList();
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return CardWidget(post: list[index]);
                          //
                        });
                  }
                },
              ),
            ),
          )

          // Consumer<API>(
          //   builder: (context, ref, child) {
          //     return StreamBuilder(
          //       stream: ref.getAllMyPosts(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasError) {
          //           return const Center(
          //             child: Text("Error"),
          //           );
          //         } else if (snapshot.connectionState ==
          //             ConnectionState.waiting) {
          //           return CardShimmer(post: list[0]);
          //         } else {
          //           return ListView.builder(
          //               shrinkWrap: true,
          //               physics: const BouncingScrollPhysics(),
          //               itemCount: list.length,
          //               itemBuilder: (context, index) {
          //                 return CardWidget(post: list[index]);
          //                 //
          //               });
          //         }
          //       },
          //     );
          //
          //     //   SizedBox(
          //     //   height: MediaQuery.of(context).size.height*0.7,
          //     //   child: Container(
          //     //     child: data.when(
          //     //       data: (data) {
          //     //         final d = data.docs;
          //     //         final d1 = ref.watch(dataProvideranother).value;
          //     //         list = d.map((e) => Post.fromJson(e.data())).toList();
          //     //
          //     //         list.addAll(d1 ?? []);
          //     //         list.sort(
          //     //           (a, b) => b.createAt.compareTo(a.createAt),
          //     //         );
          //     //
          //     //         if (list.isNotEmpty) {
          //     //           return ListView.builder(
          //     //             shrinkWrap: true,
          //     //             physics: const BouncingScrollPhysics(),
          //     //             itemCount: list.length,
          //     //             itemBuilder: (context, index) {
          //     //               return CardWidget(post: list[index]);
          //     //             },
          //     //           );
          //     //         } else {
          //     //           return const SizedBox();
          //     //
          //     //         }
          //     //       },
          //     //       loading: () {
          //     //         return ListView.builder(
          //     //           itemCount: 5,
          //     //           shrinkWrap: true,
          //     //           itemBuilder: (context, index) {
          //     //             return const CardShimmer();
          //     //           },
          //     //         );
          //     //       },
          //     //       error: (error, stackTrace) {
          //     //         return Center(
          //     //           child: Text(error.toString()),
          //     //         );
          //     //       },
          //     //     ),
          //     //   ),
          //     // );

          //   },
          // )
        ],
      ),
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
}
