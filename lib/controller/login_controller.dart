import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';
import '../utilities/tools.dart';

class LoginController extends ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // final _pref = SharedPreferences.getInstance();
  bool check = false;

  Future<bool> loginWithEmail(BuildContext context) async {
    try {
      return await Provider.of<API>(context, listen: false)
          .checkAccount(email.text, password.text);
    } catch (e) {
      printLog(e);
      Fluttertoast.showToast(msg: 'error : $e');

      return false;
    }
  }
}
