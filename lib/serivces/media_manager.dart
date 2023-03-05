import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

Future<String> SaveLocalImage(XFile? _image, String image_name) async {
  if (_image == null) {
    return 'null image ${_image}';
  }
  print('iam to save image :${File(_image.path).existsSync()} ${_image.path}');

  final Directory extDir = await getApplicationDocumentsDirectory();
  String app_path = extDir.path;
  final String copypath = '$app_path/$image_name';

  final File localImage = await File(_image.path).copy(copypath);
  print('image saved sir $localImage');
  return 'image saved';
}

Future<XFile?> GetLocalImage(context) async {
  final Rx<XFile?> _image = Rx<XFile?>(null);

  final completer = Completer<void>();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: (Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                Get.back();

                _image.value = await pickimage(ImageSource.gallery);

                completer.complete();
              },
              child: Row(
                children: [
                  Icon(Icons.image),
                  Text('From Gallery'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();

                _image.value = await pickimage(ImageSource.camera);
                completer.complete();
              },
              child: Row(
                children: [
                  Icon(Icons.camera),
                  Text('From Camera'),
                ],
              ),
            ),
          ],
        )),
      );
    },
  );

  await completer.future; // wait for image selection to complete
  return _image.value;
}

Future<XFile?> pickimage(ImageSource media) async {
  XFile? _image = await picker.pickImage(source: media);
  return _image;
}
