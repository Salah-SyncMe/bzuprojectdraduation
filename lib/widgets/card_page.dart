import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../view/my_page.dart';

class CardPage extends StatefulWidget {
  final PageUser page;

  const CardPage({super.key, required this.page});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return InkWell(
      onTap: () async {
        await api.setPageMe(widget.page);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyPage(),
            ));
      },
      child: Card(
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.page.name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26.sp,
                          color: Colors.black,
                          fontFamily: "Agbalumo")),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(api.me?.name.toString() ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontFamily: "CrimsonText")),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  width: 100.w,
                  height: 100.w,
                  imageUrl: widget.page.image,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
