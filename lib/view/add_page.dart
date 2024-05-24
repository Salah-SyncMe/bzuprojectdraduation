import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../utilities/tools.dart';
import '../widgets/card_page.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';

class CurrentPage extends StatefulWidget {
  const CurrentPage({super.key});

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  List<PageUser> list = [];
  List<PageUser> list1 = [];

  int index1 = 1;
  int counter = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Consumer<API>(
              builder: (context, value, child) => Expanded(
                child: StreamBuilder(
                  stream: value.getAllPage(),
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
                      list =
                          d!.map((e) => PageUser.fromJson(e.data())).toList();
                      printLog(list.length);
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return CardPage(page: list[index]);
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

  styleItems() {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        height: 1,
        fontSize: 20,
        color: Colors.black,
        fontFamily: "VarelaRound");
  }
}
