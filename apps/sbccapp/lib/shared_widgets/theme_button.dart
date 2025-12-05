import 'package:flutter/material.dart';

import '../core/design_system/src/theme_colors.dart';
import '../core/design_system/src/theme_fonts.dart';

/// A reusable Call-to-Action (CTA) button component with consistent styling.
///
/// This button follows the design system guidelines with:
/// - Rounded corners (12px radius)
/// - Blue Polynesian background color
/// - White text
/// - Fixed height of 50px
/// - Consistent typography using the design system fonts
///
/// Usage examples:
/// ```dart
/// // Basic usage
/// ThemeButton(
///   text: 'Continue',
///   onPressed: () => print('Button pressed'),
/// )
///
/// // With custom width
/// ThemeButton(
///   text: 'Submit',
///   onPressed: () => print('Submit pressed'),
///   width: 200,
/// )
///
/// // Disabled state
/// ThemeButton(
///   text: 'Loading...',
///   onPressed: null, // This makes the button disabled
/// )
///
/// // With loading state
/// ThemeButton(
///   text: 'Processing',
///   onPressed: () => print('Processing'),
///   isLoading: true,
/// )
/// ```
class ThemeButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when the button is pressed
  final VoidCallback? onPressed;

  /// Optional custom width for the button. If null, button will expand to fill available width
  final double? width;

  /// Whether to show a loading indicator instead of text
  final bool isLoading;

  /// Optional icon to display before the text
  final IconData? leadingIcon;

  /// Optional icon to display after the text
  final IconData? trailingIcon;

  /// Custom text style override
  final TextStyle? textStyle;

  /// Whether to show a subtle shadow for elevation
  final bool showShadow;

  /// Custom border radius (defaults to 12)
  final double borderRadius;

  const ThemeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
    this.showShadow = true,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final shouldShowBlue = onPressed != null || isLoading; // Keep blue during loading

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: shouldShowBlue ? ThemeColors.themeBlue : ThemeColors.midGrey,
        boxShadow:
            showShadow && shouldShowBlue
                ? [BoxShadow(color: ThemeColors.themeBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isEnabled ? onPressed : null,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, color: ThemeColors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                ],
                Flexible(
                  child: Text(
                    text,
                    style: textStyle ?? ThemeFonts.text16Bold(textColor: ThemeColors.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isLoading && trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, color: ThemeColors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A smaller variant of the ThemeButton with reduced height and padding.
///
/// Useful for secondary actions or when space is limited.
class ThemeButtonSmall extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when the button is pressed
  final VoidCallback? onPressed;

  /// Optional custom width for the button
  final double? width;

  /// Whether to show a loading indicator instead of text
  final bool isLoading;

  /// Optional icon to display before the text
  final IconData? leadingIcon;

  /// Optional icon to display after the text
  final IconData? trailingIcon;

  /// Custom text style override
  final TextStyle? textStyle;

  /// Whether to show a subtle shadow for elevation
  final bool showShadow;

  /// Custom border radius (defaults to 8 for smaller button)
  final double borderRadius;

  const ThemeButtonSmall({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
    this.showShadow = true,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final shouldShowBlue = onPressed != null || isLoading; // Keep blue during loading

    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: shouldShowBlue ? ThemeColors.themeBlue : ThemeColors.midGrey,
        boxShadow:
            showShadow && shouldShowBlue
                ? [BoxShadow(color: ThemeColors.themeBlue.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 1))]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isEnabled ? onPressed : null,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else ...[
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, color: ThemeColors.white, size: 16),
                    const SizedBox(width: 6),
                  ],
                ],
                Flexible(
                  child: Text(
                    text,
                    style: textStyle ?? ThemeFonts.text14Bold(textColor: ThemeColors.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isLoading && trailingIcon != null) ...[
                  const SizedBox(width: 6),
                  Icon(trailingIcon, color: ThemeColors.white, size: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
