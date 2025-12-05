import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sbccapp/core/design_system/design_system.dart';

Future<File?> customImagePicker(BuildContext context, {bool selfie = false}) async {
  if (selfie) {
    final value = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 10,
      maxWidth: 800,
      maxHeight: 800,
    );
    return value != null ? File(value.path) : null;
  } else {
    final source = await customBottomSheet(
      context: context,
      options: [
        BottomSheetOptionModel(
          name: "Camera",
          onTap: () {
            Navigator.pop(context, ImageSource.camera);
          },
        ),
        BottomSheetOptionModel(
          name: "Gallery",
          onTap: () {
            Navigator.pop(context, ImageSource.gallery);
          },
        ),
      ],
    );

    if (source != null) {
      final value = await ImagePicker().pickImage(source: source, imageQuality: 10);
      return value != null ? File(value.path) : null;
    }
    return null;
  }
}

Future<List<File>?> customMultipleImagePicker(BuildContext context) async {
  final result = await customBottomSheet(
    context: context,
    options: [
      BottomSheetOptionModel(
        name: "Camera",
        icon: Icons.camera_alt_outlined,
        onTap: () async {
          final image = await ImagePicker().pickImage(source: ImageSource.camera);
          if (image != null) {
            Navigator.pop(context, [File(image.path)]);
          }
        },
      ),
      BottomSheetOptionModel(
        name: "Gallery",
        icon: Icons.photo_outlined,
        onTap: () async {
          final images = await ImagePicker().pickMultiImage();
          if (images.isNotEmpty) {
            Navigator.pop(context, images.map((e) => File(e.path)).toList());
          }
        },
      ),
    ],
  );

  if (result != null) {
    return result.cast<File>();
  }
  return null;
}

Future customBottomSheet({
  required BuildContext context,
  required List<BottomSheetOptionModel> options,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Container(
            width: 24.96,
            height: 2.33,
            decoration: const ShapeDecoration(
              color: Colors.blue,
              shape: StadiumBorder(),
            ),
          ),
          const SizedBox(height: 30),
          ...options.map((e) {
            return ListTile(
              onTap: e.onTap,
              leading: e.icon != null
                  ? Icon(
                e.icon,
                color: Colors.black38,
              )
                  : null,
              title: Text(
                e.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

class BottomSheetOptionModel {
  String name;
  IconData? icon;
  void Function()? onTap;

  BottomSheetOptionModel({required this.name, this.icon, required this.onTap});
}

