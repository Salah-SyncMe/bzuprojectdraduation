import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';
import '../utilities/tools.dart';

class PageControllers extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  File? pathImage;

  Future<void> createPage(BuildContext context) async {
    printLog(name.text.toString());

    await Provider.of<API>(context, listen: false)
        .createPage(name.text, pathImage);

    await Fluttertoast.showToast(
        msg: "Add page successes",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 18.sp,
        gravity: ToastGravity.TOP);

    Navigator.pop(context);

    notifyListeners();
  }
}
