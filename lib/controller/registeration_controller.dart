import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../model/api.dart';
import '../utilities/tools.dart';
import '../view/home.dart';

class RegisterController extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController coPassword = TextEditingController();

  // final _pref = SharedPreferences.getInstance();
  File? pathImage;

  Future<void> registerWithEmail(BuildContext context) async {
    printLog(email.text.toString());
    printLog(pathImage.toString());
    printLog(name.text.toString());
    printLog(password.text.toString());

    if (await Provider.of<API>(context, listen: false)
            .isAddedBefore(email.text.toString()) ==
        false) {
      await Provider.of<API>(context, listen: false)
          .createUser(name.text, password.text, email.text, pathImage);

      // final SharedPreferences? pref = await _pref;
      // await pref?.setString("token", token);
      // await pref?.setString("id", id.toString());
      // await pref?.setString("name", nam.toString());
      name.clear();
      email.clear();
      password.clear();
      coPassword.clear();

      await Fluttertoast.showToast(
          msg: "Add success",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blue,
          fontSize: 18.sp,
          gravity: ToastGravity.TOP);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Home(),
      ));

      // Get.off(user());
    } else if (await Provider.of<API>(context, listen: false)
            .isAddedBefore(email.text.toString()) ==
        true) {
      Fluttertoast.showToast(
          msg:
              " error : The email address you have entered is already registered",
          toastLength: Toast.LENGTH_LONG,
          fontSize: 18.sp,
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP);
    }
    notifyListeners();
  }
}
