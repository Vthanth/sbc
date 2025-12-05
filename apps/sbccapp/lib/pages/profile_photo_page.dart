import 'dart:io';

import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/stores/user.store.dart';

class ProfilePhotoPage extends StatefulWidget {
  const ProfilePhotoPage({super.key});

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  final userStore = locator<UserStore>();
  final _imagePicker = ImagePicker();
  File? _selectedProfileImage;
  File? _selectedSignImage;
  bool _isUploading = false;
  bool _skipCropping = false; // Flag to skip cropping if it keeps failing

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        // Check if file exists
        final imageFile = File(image.path);
        if (!await imageFile.exists()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Selected image file not found')),
            );
          }
          return;
        }

        File? finalImage;
        
        // Skip cropping if it previously failed
        if (_skipCropping) {
          finalImage = imageFile;
        } else {
          try {
            // Try to crop the image
            final CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              compressQuality: 90,
              uiSettings: [
                AndroidUiSettings(
                  toolbarTitle: 'Crop Profile Photo',
                  toolbarColor: const Color(0xff052c65),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true,
                  hideBottomControls: false,
                  showCropGrid: true,
                ),
                IOSUiSettings(
                  title: 'Crop Profile Photo',
                  aspectRatioLockEnabled: true,
                  resetAspectRatioEnabled: false,
                ),
              ],
            );

            if (croppedFile != null) {
              final croppedFileCheck = File(croppedFile.path);
              if (await croppedFileCheck.exists()) {
                finalImage = croppedFileCheck;
              } else {
                finalImage = imageFile;
              }
            } else {
              // User cancelled cropping, use original
              finalImage = imageFile;
            }
          } catch (cropError, cropStackTrace) {
            debugPrint('Error cropping image: $cropError');
            debugPrint('Crop stack trace: $cropStackTrace');
            // If cropping fails, use the original image and skip cropping next time
            setState(() {
              _skipCropping = true;
            });
            finalImage = imageFile;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Using original image (crop unavailable)'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        }

        if (finalImage != null && mounted) {
          setState(() {
            _selectedProfileImage = finalImage;
          });
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error picking profile image: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          content: Text('Failed to pick profile image: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _pickSignImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        // Check if file exists
        final imageFile = File(image.path);
        if (!await imageFile.exists()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Selected image file not found')),
            );
          }
          return;
        }

        File? finalImage;
        try {
          // Try to crop the image
          final CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
            compressQuality: 90,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Sign Photo',
                toolbarColor: const Color(0xff052c65),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                lockAspectRatio: false,
                hideBottomControls: false,
                showCropGrid: true,
              ),
              IOSUiSettings(
                title: 'Crop Sign Photo',
                aspectRatioLockEnabled: false,
                resetAspectRatioEnabled: true,
              ),
            ],
          );

          if (croppedFile != null) {
            final croppedFileCheck = File(croppedFile.path);
            if (await croppedFileCheck.exists()) {
              finalImage = croppedFileCheck;
            } else {
              finalImage = imageFile;
            }
          } else {
            // User cancelled cropping, use original
            finalImage = imageFile;
          }
        } catch (cropError, cropStackTrace) {
          debugPrint('Error cropping image: $cropError');
          debugPrint('Crop stack trace: $cropStackTrace');
          // If cropping fails, use the original image
          finalImage = imageFile;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Using original image (crop unavailable)'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }

        if (finalImage != null && mounted) {
          setState(() {
            _selectedSignImage = finalImage;
          });
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error picking sign image: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          content: Text('Failed to pick sign image: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _uploadPhotos() async {
    if (_selectedProfileImage == null && _selectedSignImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select at least one image to upload')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await userStore.updateProfilePhotos(profileImage: _selectedProfileImage, signImage: _selectedSignImage);

      setState(() {
        _selectedProfileImage = null;
        _selectedSignImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photos uploaded successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload photos: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: AppBar(
        backgroundColor: ThemeColors.themeBlue,
        foregroundColor: ThemeColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Photos', style: ThemeFonts.text16Bold(textColor: ThemeColors.white)),
            Text('Manage your photos', style: ThemeFonts.text12(textColor: ThemeColors.white.withOpacity(0.8))),
          ],
        ),
      ),
      body: Observer(
        builder: (context) {
          final user = userStore.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ProfilePhotoContent(
            user: user,
            selectedProfileImage: _selectedProfileImage,
            selectedSignImage: _selectedSignImage,
            isUploading: _isUploading,
            onPickProfileImage: _pickProfileImage,
            onPickSignImage: _pickSignImage,
            onUploadPhotos: _uploadPhotos,
          );
        },
      ),
    );
  }
}

class _ProfilePhotoContent extends StatelessWidget {
  final User user;
  final File? selectedProfileImage;
  final File? selectedSignImage;
  final bool isUploading;
  final VoidCallback onPickProfileImage;
  final VoidCallback onPickSignImage;
  final VoidCallback onUploadPhotos;

  const _ProfilePhotoContent({
    required this.user,
    required this.selectedProfileImage,
    required this.selectedSignImage,
    required this.isUploading,
    required this.onPickProfileImage,
    required this.onPickSignImage,
    required this.onUploadPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Photo Section
                _PhotoCard(
                  title: 'Profile Photo',
                  subtitle: 'Your profile picture',
                  imageUrl: user.profilePhotoUrl,
                  selectedImage: selectedProfileImage,
                  onPickImage: onPickProfileImage,
                  icon: Icons.person_outline,
                  iconColor: ThemeColors.themeBlue,
                ),
                const SizedBox(height: 20),

                // Sign Photo Section
                _PhotoCard(
                  title: 'Sign Photo',
                  subtitle: 'Your signature image',
                  imageUrl: user.signPhotoUrl,
                  selectedImage: selectedSignImage,
                  onPickImage: onPickSignImage,
                  icon: Icons.draw,
                  iconColor: ThemeColors.themeBlue,
                ),
                const SizedBox(height: 20),

                // Upload Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeColors.themeBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: ThemeColors.themeBlue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select images from your gallery to update your profile and sign photos',
                          style: ThemeFonts.text14(textColor: ThemeColors.themeBlue),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom spacing
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Upload Button Section
        if (selectedProfileImage != null || selectedSignImage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.white,
              boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (selectedProfileImage != null || selectedSignImage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeColors.themeBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.2), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: ThemeColors.themeBlue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedProfileImage != null && selectedSignImage != null
                                  ? 'Profile photo and sign photo selected'
                                  : selectedProfileImage != null
                                  ? 'Profile photo selected'
                                  : 'Sign photo selected',
                              style: ThemeFonts.text12(textColor: ThemeColors.themeBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ThemeButton(
                    text: 'Upload Photos',
                    onPressed: isUploading ? null : onUploadPhotos,
                    isLoading: isUploading,
                    leadingIcon: Icons.cloud_upload,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final IconData icon;
  final Color iconColor;

  const _PhotoCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.selectedImage,
    required this.onPickImage,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
                      Text(subtitle, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Display
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedImage != null ? ThemeColors.themeBlue : ThemeColors.lightGrey,
                  width: selectedImage != null ? 3 : 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    _buildImage(),
                    if (selectedImage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ThemeColors.themeBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('NEW', style: ThemeFonts.text10(textColor: ThemeColors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Upload Button
            SizedBox(
              width: double.infinity,
              child: ThemeButton(
                text:
                    selectedImage != null
                        ? 'Change Image'
                        : (imageUrl != null && imageUrl!.isNotEmpty)
                        ? 'Change Image'
                        : 'Upload Image',
                onPressed: onPickImage,
                leadingIcon:
                    selectedImage != null || (imageUrl != null && imageUrl!.isNotEmpty)
                        ? Icons.edit
                        : Icons.add_a_photo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (selectedImage != null) {
      // Show selected image from gallery
      return Image.file(selectedImage!, width: double.infinity, height: 200, fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Show existing image from server
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: ThemeColors.lightGrey.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
              ),
            ),
          );
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ThemeColors.lightGrey.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 48, color: ThemeColors.midGrey),
          const SizedBox(height: 8),
          Text('No image available', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
          const SizedBox(height: 4),
          Text('Tap "Upload Image" to add one', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}
