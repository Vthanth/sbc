import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/stores/user.store.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final userStore = UserStore();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon with better styling
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.themeBlue.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Icons.check_circle_outline, color: ThemeColors.themeBlue, size: 80),
              ),
              const SizedBox(height: 32),

              // Welcome Text with better typography
              Text(
                'Welcome!',
                style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description Text with better styling
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: ThemeColors.opacitiesBlack10, blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: ThemeColors.themeBlue, size: 24),
                    const SizedBox(height: 12),
                    Text(
                      'Account Pending Approval',
                      style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please ask the admin to approve your account. Once approved, you will be able to access the application.',
                      style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Button with better spacing
              ThemeButton(
                text: 'Check Approval Status',
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          final isAuthenticated = await userStore.checkUserAuthentication();
                          setState(() {
                            _isLoading = false;
                          });

                          if (isAuthenticated) {
                            context.go('/home');
                          }
                        },
                isLoading: _isLoading,
                leadingIcon: Icons.refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
