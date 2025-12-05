import 'dart:io';

import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/service_locator.dart';

class ChallanMultiImageUploaderHelper {
  static Future<void> uploadImages({
    required BuildContext context,
    required List<File> images,
    required String ticketUuid,
    required VoidCallback onImagesUploaded,
  }) async {
    if (images.isNotEmpty) {
      try {
        showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

        // Upload images
        await Future.delayed(const Duration(seconds: 2));
        await locator<UserRepository>().uploadMultipleTicketImages(ticketUuid: ticketUuid, images: images);

        // Remove loader
        Navigator.pop(context);
        onImagesUploaded();
      } catch (e) {
        // Add Full screen loader
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload images'), backgroundColor: ThemeColors.red400));
        Navigator.pop(context);
      }

      return;
    }
  }
}
