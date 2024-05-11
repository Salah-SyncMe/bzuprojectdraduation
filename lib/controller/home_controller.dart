import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  Function(int index, Function(BuildContext context) onFinish)? changePage;
  bool? likeProvider;
}
