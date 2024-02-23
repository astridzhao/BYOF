import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

PickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  } else {
    print("no image selected");
    return null;
  }
}
