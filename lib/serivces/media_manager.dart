import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

// Future<String> SaveLocalImage(XFile? _image, String image_name) async {
//   if (_image == null) {
//     return 'null image ${_image}';
//   }
//   print('iam to save image :${File(_image.path).existsSync()} ${_image.path}');

//   final Directory extDir = await getApplicationDocumentsDirectory();
//   String app_path = extDir.path;
//   final String copypath = '$app_path/$image_name';

//   final File localImage = await File(_image.path).copy(copypath);
//   print('image saved sir $localImage');
//   return 'image saved';
// }

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

void EmojiPiker() {
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();
  TextEditingController textcon = TextEditingController();

  EmojiPicker(
    onEmojiSelected: (Category category, Emoji emoji) {
      // Do something when emoji is tapped (optional)
    },
    config: Config(
      columns: 7,
      emojiSizeMax: 32 *
          (foundation.defaultTargetPlatform == TargetPlatform.iOS
              ? 1.30
              : 1.0), // Issue: http://github.com/flutter/flutter/issues/28894
      verticalSpacing: 0,
      horizontalSpacing: 0,
      gridPadding: EdgeInsets.zero,
      initCategory: Category.RECENT,
      bgColor: Color(0xFFF2F2F2),
      indicatorColor: Colors.blue,
      iconColor: Colors.grey,
      iconColorSelected: Colors.blue,
      backspaceColor: Colors.blue,
      skinToneDialogBgColor: Colors.white,
      skinToneIndicatorColor: Colors.grey,
      enableSkinTones: true,
      showRecentsTab: true,
      recentsLimit: 28,
      noRecents: const Text(
        'No Recents',
        style: TextStyle(fontSize: 20, color: Colors.black26),
        textAlign: TextAlign.center,
      ), // Needs to be const Widget
      tabIndicatorAnimDuration: kTabScrollDuration,
      categoryIcons: const CategoryIcons(),
      buttonMode: ButtonMode.MATERIAL,
    ),
  );
}
