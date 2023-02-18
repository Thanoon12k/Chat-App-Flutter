import 'dart:io';

import 'package:chatapp/widgets/LABELS.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputs extends GetxController {
  dynamic context;

  bool got_image = false;
  ImageInputs({
    this.context,
  });
  XFile? image;
  final ImagePicker picker = ImagePicker();

  imagewidget() {
    return imagebutton();
  }

  imagebox(image) {
    print('got -image = *********** $image != null');
    return Center(
      child: image != null
          ? Image.file(File(image!.path), width: 150)
          : Text(
              "No image selected.",
              style: TextStyle(color: Colors.red),
            ),
    );
  }

  imagebutton() {
    return Obx(() => Center(
          child: IconButton(
              onPressed: () => sourcedialoge(),
              icon: Icon(Icons.camera_alt_outlined),
              iconSize: 40),
        ));
  }

  sourcedialoge() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    getImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  //if user click this button. user can upload image from camera
                  onPressed: () {
                    Get.back();
                    getImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    image = await picker.pickImage(source: media);
    update();
  }
}
