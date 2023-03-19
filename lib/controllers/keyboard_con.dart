import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KeyboardController extends GetxController {
  Rx<XFile?> msg_image = Rx<XFile?>(null);

  var isEmojiVisible = false.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.dispose();
  }
}
