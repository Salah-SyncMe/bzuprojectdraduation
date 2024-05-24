import 'package:bzushadengraduation/view/profile/profile_sub_image_and_image.dart';
import 'package:bzushadengraduation/widgets/card_post_with_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/api.dart';
import '../../model/post.dart';
import '../../widgets/card_post.dart';
import '../../widgets/card_shimmer.dart';
import '../../widgets/error_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Post> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileSubImageAndImage(),
              Consumer<API>(
                builder: (context, value, child) => SizedBox(
                  width: MediaQuery.of(context).size.height * 0.6,
                  child: StreamBuilder(
                    stream: value.getAllMyPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.2),
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
                        list =
                            (d!.map((e) => Post.fromJson(e.data())).toList());

                        return list.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.10.h),
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
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return (list[index].images.isEmpty
                                      ? CardPost(post: list[index])
                                      : CardPostWithPicture(
                                          post: list[index],
                                          image: list[index].images[0]));
                                });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
