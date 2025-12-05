import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';

/// Common Image Upload Section Widget
class ImageUploadSection extends StatefulWidget {
  final List<File> images;
  final Function(List<File>) onImagesChanged;
  final int maxImages;
  final bool isUploaded;

  const ImageUploadSection({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 5,
    this.isUploaded = false,
  });

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (widget.isUploaded) return;

    try {
      if (source == ImageSource.gallery) {
        // For gallery, allow multiple image selection
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
          limit: 10,
        );

        if (images.isNotEmpty) {
          final List<File> imageFiles = images.map((xFile) => File(xFile.path)).toList();

          // Check if adding these images would exceed the limit
          final int availableSlots = widget.maxImages - widget.images.length;
          final int imagesToAdd = imageFiles.length > availableSlots ? availableSlots : imageFiles.length;

          if (imagesToAdd < imageFiles.length) {
            _showMaxImagesDialog();
          }

          if (imagesToAdd > 0) {
            final List<File> updatedImages = List.from(widget.images)..addAll(imageFiles.take(imagesToAdd));
            widget.onImagesChanged(updatedImages);
          }
        }
      } else {
        // For camera, single image selection
        final XFile? image = await _picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024, maxHeight: 1024);

        if (image != null) {
          final File imageFile = File(image.path);
          final List<File> updatedImages = List.from(widget.images)..add(imageFile);
          widget.onImagesChanged(updatedImages);
        }
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  void _removeImage(int index) {
    if (widget.isUploaded) return;

    final List<File> updatedImages = List.from(widget.images);
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  void _showImageSourceDialog() {
    if (widget.isUploaded) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Image Source', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ThemeButton(
                      text: 'Camera',
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      leadingIcon: Icons.camera_alt,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ThemeButton(
                      text: 'Gallery',
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      leadingIcon: Icons.photo_library,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(color: ThemeColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: Text('Cancel', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMaxImagesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Maximum Images Reached', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
          content: Text(
            'You can only upload up to ${widget.maxImages} images. Some images were not added because they would exceed the limit.',
            style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: ThemeFonts.text16Bold(textColor: ThemeColors.notificationRed)),
          content: Text(message, style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      title: 'Images',
      icon: Icons.photo_camera,
      children: [
        Row(
          children: [
            Expanded(
              child: ThemeButton(
                text: widget.isUploaded ? 'Images Uploaded' : 'Add Image',
                onPressed:
                    widget.isUploaded
                        ? null
                        : (widget.images.length < widget.maxImages ? _showImageSourceDialog : null),
                leadingIcon: widget.isUploaded ? Icons.check_circle : Icons.add_a_photo,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${widget.images.length}/${widget.maxImages}',
              style: ThemeFonts.text14(textColor: widget.isUploaded ? ThemeColors.themeBlue : ThemeColors.midGrey),
            ),
          ],
        ),
        if (widget.images.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ImagesGrid(images: widget.images, onRemoveImage: _removeImage, isUploaded: widget.isUploaded),
        ],
      ],
    );
  }
}

/// Images Grid Widget
class _ImagesGrid extends StatelessWidget {
  final List<File> images;
  final Function(int) onRemoveImage;
  final bool isUploaded;

  const _ImagesGrid({required this.images, required this.onRemoveImage, required this.isUploaded});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUploaded ? 'Uploaded Images' : 'Images',
              style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return _ImageItem(image: images[index], onRemove: () => onRemoveImage(index), isUploaded: isUploaded);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual Image Item Widget
class _ImageItem extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;
  final bool isUploaded;

  const _ImageItem({required this.image, required this.onRemove, required this.isUploaded});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isUploaded ? ThemeColors.themeBlue : ThemeColors.lightGrey),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(image, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          ),
          if (!isUploaded)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: ThemeColors.notificationRed, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: ThemeColors.white, size: 16),
                ),
              ),
            ),
          if (isUploaded)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: ThemeColors.themeBlue, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: ThemeColors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

/// Form Section Container (internal helper)
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: ThemeColors.themeBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
