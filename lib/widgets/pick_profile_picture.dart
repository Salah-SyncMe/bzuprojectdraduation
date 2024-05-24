import 'dart:io';
import 'package:bzushadengraduation/utilities/tools.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/api.dart';

class PickPicture extends StatefulWidget {
  const PickPicture({super.key});

  @override
  State<PickPicture> createState() => _PickPictureState();
}

class _PickPictureState extends State<PickPicture> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    printLog("jjjjjjjjjjjjjj");
    return AnimatedContainer(
      curve: Curves.linear,
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          image: DecorationImage(
              image: AssetImage("images/bottom.jpg"), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Pick Profile Picture",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'CrimsonText'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          api.updateMyPicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.image_search,
                        size: 50,
                      ))),
              Expanded(
                  child: IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          api.updateMyPicture(File(_image!));

                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_outlined, size: 50))),
            ],
          )
        ],
      ),
    );
  }
}
