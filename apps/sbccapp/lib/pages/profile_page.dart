import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/profile_photo_page.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';
import 'package:sbccapp/stores/user.store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userStore = locator<UserStore>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  bool _isEditing = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  String _originalName = '';
  String _originalEmail = '';
  String _originalPhoneNumber = '';

  @override
  void initState() {
    userStore.loadProfile();
    _nameController.addListener(_updateHasChanges);
    _emailController.addListener(_updateHasChanges);
    _phoneNumberController.addListener(_updateHasChanges);
    _nameFocusNode.addListener(_onFocusChange);
    _emailFocusNode.addListener(_onFocusChange);
    _phoneNumberFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateHasChanges);
    _emailController.removeListener(_updateHasChanges);
    _phoneNumberController.removeListener(_updateHasChanges);
    _nameFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.removeListener(_onFocusChange);
    _phoneNumberFocusNode.removeListener(_onFocusChange);
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    final user = userStore.currentUser;
    if (user == null) {
      return;
    }
    _nameController.text = user.name ?? '';
    _originalName = user.name ?? '';
    _emailController.text = user.email ?? '';
    _originalEmail = user.email ?? '';
    _phoneNumberController.text = user.phoneNumber ?? '';
    _originalPhoneNumber = user.phoneNumber ?? '';
    setState(() {
      _isEditing = true;
    });
    _updateHasChanges();
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _hasChanges = false;
    });
  }

  void _showQRCodeDialog() {
    userStore.loadQRCode();
    showDialog(context: context, builder: (context) => const _QRCodeDialog());
  }

  void _updateHasChanges() {
    final nameChanged = _isEditing && _nameController.text.trim() != _originalName;
    final emailChanged = _isEditing && _emailController.text.trim() != _originalEmail;
    final phoneNumberChanged = _isEditing && _phoneNumberController.text.trim() != _originalPhoneNumber;

    final newHasChanges = nameChanged || emailChanged || phoneNumberChanged;

    if (_hasChanges != newHasChanges) {
      setState(() {
        _hasChanges = newHasChanges;
      });
    }
  }

  void _onFocusChange() {
    // Update hasChanges when focus changes to ensure save button state is correct
    _updateHasChanges();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email cannot be empty')));
      return;
    }

    if (_phoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone number cannot be empty')));
      return;
    }

    if (_phoneNumberController.text.trim().length > 15) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Phone number cannot be more than 15 characters')));
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid email address')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await userStore.updateProfileData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
      );
      setState(() {
        _isEditing = false;
        _originalName = _nameController.text.trim();
        _originalEmail = _emailController.text.trim();
        _originalPhoneNumber = _phoneNumberController.text.trim();
        _hasChanges = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: _ProfileAppBar(
        isEditing: _isEditing,
        onBackPressed: () => context.pop(),
        onEditPressed: _isEditing ? _cancelEditing : _startEditing,
      ),
      body: Observer(
        builder: (_) {
          final user = userStore.currentUser;
          if (user == null) {
            return _LoadingView();
          }
          return _ProfileContent(
            user: user,
            isEditing: _isEditing,
            isSaving: _isSaving,
            hasChanges: _hasChanges,
            nameController: _nameController,
            emailController: _emailController,
            phoneNumberController: _phoneNumberController,
            nameFocusNode: _nameFocusNode,
            emailFocusNode: _emailFocusNode,
            phoneNumberFocusNode: _phoneNumberFocusNode,
            onShowQRCode: _showQRCodeDialog,
            onSaveProfile: _saveProfile,
            onCancelEditing: _cancelEditing,
          );
        },
      ),
    );
  }
}

/// Custom AppBar for profile page
class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;
  final VoidCallback onBackPressed;
  final VoidCallback onEditPressed;

  const _ProfileAppBar({required this.isEditing, required this.onBackPressed, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.white,
      foregroundColor: ThemeColors.primaryBlack,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ThemeColors.primaryBlack),
        onPressed: onBackPressed,
      ),
      title: Text(
        'Profile',
        style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
      ),
      actions: [
        IconButton(
          icon: Icon(isEditing ? Icons.close : Icons.edit, color: ThemeColors.primaryBlack),
          onPressed: onEditPressed,
          tooltip: isEditing ? 'Cancel' : 'Edit Profile',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main profile content
class _ProfileContent extends StatelessWidget {
  final dynamic user;
  final bool isEditing;
  final bool isSaving;
  final bool hasChanges;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode phoneNumberFocusNode;
  final VoidCallback onShowQRCode;
  final VoidCallback onSaveProfile;
  final VoidCallback onCancelEditing;

  const _ProfileContent({
    required this.user,
    required this.isEditing,
    required this.isSaving,
    required this.hasChanges,
    required this.nameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.phoneNumberFocusNode,
    required this.onShowQRCode,
    required this.onSaveProfile,
    required this.onCancelEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Photo Section
                  _ProfilePhotoSection(
                    user: user,
                    onEditPhoto: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePhotoPage())),
                  ),
                  const SizedBox(height: 24),

                  // User Details
                  _UserDetailsSection(
                    user: user,
                    isEditing: isEditing,
                    nameController: nameController,
                    emailController: emailController,
                    phoneNumberController: phoneNumberController,
                    nameFocusNode: nameFocusNode,
                    emailFocusNode: emailFocusNode,
                    phoneNumberFocusNode: phoneNumberFocusNode,
                  ),
                  const SizedBox(height: 24),

                  // Download QR Button
                  _DownloadQRButtonSection(onShowQRCode: onShowQRCode),

                  // Bottom spacing
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Save Button Section
        if (isEditing)
          _SaveButtonSection(
            isSaving: isSaving,
            hasChanges: hasChanges,
            onSave: onSaveProfile,
            onCancel: onCancelEditing,
          ),
      ],
    );
  }
}

/// Profile Photo Section
class _ProfilePhotoSection extends StatelessWidget {
  final dynamic user;
  final VoidCallback onEditPhoto;

  const _ProfilePhotoSection({required this.user, required this.onEditPhoto});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title with icon
        Row(
          children: [
            Icon(Icons.person, color: ThemeColors.themeBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Profile Photo',
              style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Profile Photo Display
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.2), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.themeBlue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
                    ? Image.network(
                        user.profilePhotoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
                              strokeWidth: 2,
                            ),
                          );
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.white, width: 3),
                ),
                child: Icon(Icons.camera_alt, color: ThemeColors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ThemeButton(
          text: 'Change Photo',
          onPressed: onEditPhoto,
          leadingIcon: Icons.edit,
          width: 200,
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ThemeColors.lightGrey.withOpacity(0.3),
      child: Icon(Icons.person, size: 60, color: ThemeColors.midGrey),
    );
  }
}

/// Download QR Button Section
class _DownloadQRButtonSection extends StatelessWidget {
  final VoidCallback onShowQRCode;

  const _DownloadQRButtonSection({required this.onShowQRCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.qr_code, color: ThemeColors.themeBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Profile QR Code',
              style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ThemeButton(
          text: 'Download Profile QR',
          onPressed: onShowQRCode,
          leadingIcon: Icons.download,
          width: double.infinity,
        ),
      ],
    );
  }
}

/// User Details Section
class _UserDetailsSection extends StatelessWidget {
  final dynamic user;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode phoneNumberFocusNode;

  const _UserDetailsSection({
    required this.user,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.phoneNumberFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        _DetailField(
          label: 'Name',
          value: user.name ?? '',
          isEditing: isEditing,
          controller: nameController,
          focusNode: nameFocusNode,
          icon: Icons.person_outline,
          iconColor: ThemeColors.themeBlue,
        ),
        const SizedBox(height: 20),
        // Email Field
        _DetailField(
          label: 'Email',
          value: user.email ?? '',
          isEditing: isEditing,
          controller: emailController,
          focusNode: emailFocusNode,
          icon: Icons.email_outlined,
          iconColor: ThemeColors.themeBlue,
          isEmail: true,
        ),
        const SizedBox(height: 20),
        // Phone Number Field
        _DetailField(
          label: 'Phone Number',
          value: user.phoneNumber ?? '',
          isEditing: isEditing,
          controller: phoneNumberController,
          focusNode: phoneNumberFocusNode,
          icon: Icons.phone_outlined,
          iconColor: ThemeColors.themeBlue,
          isPhoneNumber: true,
        ),
      ],
    );
  }
}

/// Detail Field Widget
class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final Color iconColor;
  final bool isEmail;
  final bool isPhoneNumber;

  const _DetailField({
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
    required this.focusNode,
    required this.icon,
    required this.iconColor,
    this.isEmail = false,
    this.isPhoneNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isEditing) ...[
          isEmail
              ? ThemeTextField(
                  label: label,
                  controller: controller,
                  focusNode: focusNode,
                  hint: 'Enter your email',
                  inputType: TextInputType.emailAddress,
                )
              : isPhoneNumber
                  ? ThemeTextField(
                      label: label,
                      controller: controller,
                      focusNode: focusNode,
                      hint: 'Enter your phone number',
                      inputType: TextInputType.phone,
                      maxLength: 15,
                    )
                  : ThemeTextField(
                      label: label,
                      controller: controller,
                      focusNode: focusNode,
                      hint: 'Enter your $label',
                    ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              value.isNotEmpty ? value : 'Not provided',
              style: ThemeFonts.text18(
                textColor: value.isNotEmpty ? ThemeColors.primaryBlack : ThemeColors.midGrey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Save button section
class _SaveButtonSection extends StatelessWidget {
  final bool isSaving;
  final bool hasChanges;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _SaveButtonSection({
    required this.isSaving,
    required this.hasChanges,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSaving ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: ThemeColors.lightGrey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ThemeButton(
                text: 'Save',
                onPressed: (isSaving || !hasChanges) ? null : onSave,
                isLoading: isSaving,
                leadingIcon: Icons.save,
                borderRadius: 6.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading view
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: ThemeColors.themeBlue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text('Loading profile...', style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: ThemeColors.notificationRed.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 48, color: ThemeColors.notificationRed),
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading Profile',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(error, style: ThemeFonts.text14(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Empty state view
class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: ThemeColors.lightGrey.withOpacity(0.3), shape: BoxShape.circle),
              child: Icon(Icons.person_outline, size: 48, color: ThemeColors.midGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Profile Found',
              style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load your profile information.',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// QR Code dialog with modern design
class _QRCodeDialog extends StatelessWidget {
  const _QRCodeDialog();

  @override
  Widget build(BuildContext context) {
    final userStore = locator<UserStore>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 30, offset: const Offset(0, 15))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ThemeColors.themeBlue, ThemeColors.themeBlue.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.qr_code, color: ThemeColors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile QR Code', style: ThemeFonts.text16Bold(textColor: ThemeColors.white)),
                          Text(
                            'Share your profile with others',
                            style: ThemeFonts.text12(textColor: ThemeColors.white.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: ThemeColors.white, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: ThemeColors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Observer(
                builder: (_) {
                  return userStore.qrCode.maybeWhen(
                    (qrCodeBytes) => _QRCodeContent(qrCodeBytes: qrCodeBytes),
                    loading: () => const _QRCodeLoadingView(),
                    error:
                        (error, message) => _QRCodeErrorView(
                          message: message ?? 'Failed to load QR code',
                          onRetry: () => userStore.loadQRCode(),
                        ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// QR Code content
class _QRCodeContent extends StatelessWidget {
  final Uint8List qrCodeBytes;

  const _QRCodeContent({required this.qrCodeBytes});

  Future<void> _downloadQRCode(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading QR code...'), duration: Duration(seconds: 2)),
      );

      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      // Create directory if it doesn't exist
      final directory = Directory(dirloc);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_qr_$timestamp.png';
      final filePath = '$dirloc$fileName';

      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(qrCodeBytes);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code downloaded successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading QR code: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // QR Code Container with enhanced styling
        SizedBox(
          width: 220,
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.memory(qrCodeBytes, width: 180, height: 180, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 24),

        // Instructions
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
                  'Scan this QR code with your camera or QR scanner app to view this profile',
                  style: ThemeFonts.text14(textColor: ThemeColors.themeBlue),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Download Button
        ThemeButton(
          text: 'Download QR Code',
          onPressed: () => _downloadQRCode(context),
          leadingIcon: Icons.download,
          width: double.infinity,
        ),
      ],
    );
  }
}

/// QR Code loading view
class _QRCodeLoadingView extends StatelessWidget {
  const _QRCodeLoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Loading Container with enhanced styling
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ThemeColors.primarySand, ThemeColors.white],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: ThemeColors.themeBlue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ThemeColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.themeBlue.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Generating QR Code...', style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue)),
                const SizedBox(height: 4),
                Text('Please wait a moment', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// QR Code error view
class _QRCodeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QRCodeErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Error Container with enhanced styling
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ThemeColors.notificationRed.withOpacity(0.05), ThemeColors.white],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.notificationRed.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ThemeColors.notificationRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.error_outline, size: 48, color: ThemeColors.notificationRed),
                ),
                const SizedBox(height: 16),
                Text('Failed to Generate', style: ThemeFonts.text16Bold(textColor: ThemeColors.notificationRed)),
                const SizedBox(height: 8),
                Text(message, style: ThemeFonts.text12(textColor: ThemeColors.midGrey), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Retry Button
        ThemeButton(text: 'Try Again', onPressed: onRetry, leadingIcon: Icons.refresh),
      ],
    );
  }
}
