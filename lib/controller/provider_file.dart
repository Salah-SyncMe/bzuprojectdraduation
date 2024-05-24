import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../model/post.dart';

class CustomFileImage extends ChangeNotifier {
  late File file = File("");
  List<Post> h = [];
  bool isLoad = false;
  var imagePicker = ImagePicker();

  changeFileGalary() async {
    var imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      file = File(imagePicked.path);
      // var random = Random().nextInt(10000000);
      // var rand = "$random${imagepicked.name}";
    } else {
      // print("null");
    }
    notifyListeners();
  }

  isLoader(bool isLoading) {
    isLoad = isLoading;
    // notifyListeners();
  }

  changelist(List<Post> list) {
    h = list;
  }

  changeFileCamera() async {
    var imagePicked = await imagePicker.pickImage(source: ImageSource.camera);
    if (imagePicked != null) {
      file = File(imagePicked.path);
      // var random = Random().nextInt(10000000);
      // var rand = "$random${imagepicked.name}";
    } else {}
    notifyListeners();
  }

  File file2() {
    return file;
  }

  List<Post> list() {
    return h;
  }
}
