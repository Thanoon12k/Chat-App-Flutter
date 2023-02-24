import 'dart:io';

import 'package:chatapp/widgets/LABELS.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputs extends GetxController {
  // dynamic context;
   XFile? image;

  // ImageInputs({
  //    this.context,
  // });
  final ImagePicker picker = ImagePicker();

  imagewidget(context) {
    return Column(children: [imagebutton(context), imagebox(context)]);
  }

  imagebutton(context) {
    return Center(
      child: IconButton(
          onPressed: () => sourcedialoge(context),
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 40),
    );
  }

  sourcedialoge(context) {
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

  imagebox(context) {
    bool is_image = (image != null);
    return Center(
      child: is_image
          ? Image.file(File(image!.path), width: 150)
          : Text(
              "No image selected.",
              style: TextStyle(color: Colors.red),
            ),
    );
  }

  Future getImage(ImageSource media) async {
    image = await picker.pickImage(source: media);
    update();
  }
}
