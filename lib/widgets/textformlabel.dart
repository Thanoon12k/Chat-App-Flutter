
import 'package:flutter/material.dart';

class MyTextFormLabel extends StatelessWidget {
  final String? label_text;
  final FontWeight? label_fontweight;
  final double? label_fontsize;
  final Color? label_color;

  MyTextFormLabel({
    required this.label_text,
    this.label_fontweight,
    this.label_fontsize,
    this.label_color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Text(
        label_text ?? ' label',
        style: TextStyle(
          fontWeight: label_fontweight ?? FontWeight.w600,
          fontSize: label_fontsize ?? 14,
          color: label_color ?? Color.fromARGB(255, 12, 12, 12),
        ),
      ),
    );
  }
}
