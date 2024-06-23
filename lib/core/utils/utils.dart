import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

Future<File?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return null;
    return File(result.files.first.xFile.path);
  } catch (e) {
    return null;
  }
}

Future<File?> pickAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null) return null;
    return File(result.files.first.xFile.path);
  } catch (e) {
    return null;
  }
}

String rgbaToHex(Color color) {
  return color.value.toRadixString(16).substring(2);
}

Color hexToColor(String hex) {
  return Color(int.parse('0xFF$hex'));
}
