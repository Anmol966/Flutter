import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePiccker extends StatefulWidget {
  final void Function(File pickedImageFile) imagePickFn;
  ImagePiccker(this.imagePickFn);

  @override
  State<ImagePiccker> createState() => _ImagePicckerState();
}

class _ImagePicckerState extends State<ImagePiccker> {
  File? _pickedImage = null;

  void _pickImage() async {
    final ImagePicker picker = new ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.pinkAccent)),
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Add Image")),
      ],
    );
  }
}
