import 'package:flutter/material.dart';

import '../core/design_system/src/theme_colors.dart';
import 'theme_button.dart';

/// Example page demonstrating various ThemeButton usage patterns.
///
/// This file serves as both documentation and a testing ground for the ThemeButton component.
/// You can use this as a reference when implementing buttons throughout the app.
class ThemeButtonExamples extends StatefulWidget {
  const ThemeButtonExamples({super.key});

  @override
  State<ThemeButtonExamples> createState() => _ThemeButtonExamplesState();
}

class _ThemeButtonExamplesState extends State<ThemeButtonExamples> {
  bool _isLoading = false;

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThemeButton Examples'),
        backgroundColor: ThemeColors.themeBlue,
        foregroundColor: ThemeColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Basic Usage',
              description: 'Standard CTA buttons with different text',
              children: [
                ThemeButton(text: 'Continue', onPressed: () => _showSnackBar('Continue pressed')),
                const SizedBox(height: 12),
                ThemeButton(text: 'Submit Order', onPressed: () => _showSnackBar('Submit pressed')),
                const SizedBox(height: 12),
                ThemeButton(text: 'Save Changes', onPressed: () => _showSnackBar('Save pressed')),
              ],
            ),

            _buildSection(
              title: 'With Icons',
              description: 'Buttons with leading and trailing icons',
              children: [
                ThemeButton(
                  text: 'Add to Cart',
                  onPressed: () => _showSnackBar('Add to cart pressed'),
                  leadingIcon: Icons.shopping_cart,
                ),
                const SizedBox(height: 12),
                ThemeButton(
                  text: 'Download',
                  onPressed: () => _showSnackBar('Download pressed'),
                  trailingIcon: Icons.download,
                ),
                const SizedBox(height: 12),
                ThemeButton(
                  text: 'Share',
                  onPressed: () => _showSnackBar('Share pressed'),
                  leadingIcon: Icons.share,
                  trailingIcon: Icons.arrow_forward,
                ),
              ],
            ),

            _buildSection(
              title: 'Loading States',
              description: 'Buttons with loading indicators',
              children: [
                ThemeButton(
                  text: 'Processing...',
                  onPressed: _isLoading ? null : _simulateLoading,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 12),
                ThemeButton(text: 'Upload File', onPressed: () => _showSnackBar('Upload pressed'), isLoading: true),
              ],
            ),

            _buildSection(
              title: 'Disabled States',
              description: 'Buttons that are disabled or inactive',
              children: [
                ThemeButton(
                  text: 'Disabled Button',
                  onPressed: null, // This makes it disabled
                ),
                const SizedBox(height: 12),
                ThemeButton(text: 'Loading...', onPressed: null, isLoading: true),
              ],
            ),

            _buildSection(
              title: 'Custom Width',
              description: 'Buttons with specific widths',
              children: [
                ThemeButton(
                  text: 'Fixed Width (200px)',
                  onPressed: () => _showSnackBar('Fixed width pressed'),
                  width: 200,
                ),
                const SizedBox(height: 12),
                ThemeButton(text: 'Narrow (150px)', onPressed: () => _showSnackBar('Narrow pressed'), width: 150),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: ThemeButton(text: 'Left', onPressed: () => _showSnackBar('Left pressed'))),
                    const SizedBox(width: 12),
                    Expanded(child: ThemeButton(text: 'Right', onPressed: () => _showSnackBar('Right pressed'))),
                  ],
                ),
              ],
            ),

            _buildSection(
              title: 'Small Variant',
              description: 'Smaller buttons for secondary actions',
              children: [
                ThemeButtonSmall(text: 'Small Button', onPressed: () => _showSnackBar('Small button pressed')),
                const SizedBox(height: 12),
                ThemeButtonSmall(
                  text: 'With Icon',
                  onPressed: () => _showSnackBar('Small with icon pressed'),
                  leadingIcon: Icons.edit,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: ThemeButtonSmall(text: 'Cancel', onPressed: () => _showSnackBar('Cancel pressed'))),
                    const SizedBox(width: 8),
                    Expanded(child: ThemeButton(text: 'Confirm', onPressed: () => _showSnackBar('Confirm pressed'))),
                  ],
                ),
              ],
            ),

            _buildSection(
              title: 'Custom Styling',
              description: 'Buttons with custom text styles and shadows',
              children: [
                ThemeButton(
                  text: 'Custom Font Size',
                  onPressed: () => _showSnackBar('Custom font pressed'),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ThemeColors.white),
                ),
                const SizedBox(height: 12),
                ThemeButton(text: 'No Shadow', onPressed: () => _showSnackBar('No shadow pressed'), showShadow: false),
                const SizedBox(height: 12),
                ThemeButton(
                  text: 'Custom Border Radius',
                  onPressed: () => _showSnackBar('Custom radius pressed'),
                  borderRadius: 20,
                ),
              ],
            ),

            _buildSection(
              title: 'Real-world Examples',
              description: 'Common button patterns used in the app',
              children: [
                // Login button
                ThemeButton(
                  text: 'Sign In',
                  onPressed: () => _showSnackBar('Sign in pressed'),
                  leadingIcon: Icons.login,
                ),
                const SizedBox(height: 12),

                // Order confirmation
                ThemeButton(
                  text: 'Confirm Order',
                  onPressed: () => _showSnackBar('Order confirmed'),
                  leadingIcon: Icons.check_circle,
                ),
                const SizedBox(height: 12),

                // Profile actions
                Row(
                  children: [
                    Expanded(
                      child: ThemeButtonSmall(
                        text: 'Edit Profile',
                        onPressed: () => _showSnackBar('Edit profile pressed'),
                        leadingIcon: Icons.edit,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ThemeButtonSmall(
                        text: 'Settings',
                        onPressed: () => _showSnackBar('Settings pressed'),
                        leadingIcon: Icons.settings,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Checkout flow
                ThemeButton(
                  text: 'Proceed to Checkout',
                  onPressed: () => _showSnackBar('Checkout pressed'),
                  trailingIcon: Icons.arrow_forward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String description, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColors.primaryBlack)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 14, color: ThemeColors.midGrey)),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeColors.themeBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
