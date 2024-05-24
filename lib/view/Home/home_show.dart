import 'package:bzushadengraduation/view/create_page.dart';
import 'package:bzushadengraduation/widgets/card_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../animation/animation.dart';
import '../../model/api.dart';
import '../../model/post.dart';
import '../../widgets/card_post_with_picture.dart';
import '../../widgets/card_shimmer.dart';
import '../../widgets/error_widget.dart';
import '../create_post.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    blurStyle: BlurStyle.outer,
                    color: Colors.black,
                    blurRadius: 20,
                    spreadRadius: 0)
              ]),
          child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Colors.white,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(color: Colors.black, width: 2)),
              onPressed: () async {
                Navigator.push(context, Animations(page: CreatePage(api: api)));
              },
              child: SvgPicture.asset('images/add-file.svg',
                  width: 20.w,
                  height: 20.w,
                  colorFilter: const ColorFilter.mode(
                      Colors.blueAccent, BlendMode.srcIn))),
        ),
      ),
      body: SafeArea(
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
              builder: (context, value, child) => Expanded(
                child: StreamBuilder(
                  stream: value.getPagesAllMeAndPostsPagesAndPostUser(),
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
                      list = d!.map((e) => Post.fromJson(e)).toList();
                      list.sort(
                        (a, b) => b.createAt.compareTo(a.createAt),
                      );
                      return list.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.20.h),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "No have any Post",
                                        style: TextStyle(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: "Agbalumo"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return (list[index].images.isEmpty
                                    ? CardPost(post: list[index])
                                    : CardPostWithPicture(
                                        post: list[index],
                                        image: list[index].images[0]));
                                //
                              });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
