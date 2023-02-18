import 'package:flutter/material.dart';

savebutton() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 255, 255),
          onPrimary: Color.fromARGB(255, 0, 0, 0),
        ),
        onPressed: () {},
        child: const Text(
          'حفظ',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}
