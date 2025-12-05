import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design_system/src/theme_colors.dart';
import '../core/design_system/src/theme_fonts.dart';

/// A reusable text field component that follows the SBCC design system.
///
/// This text field provides consistent styling across the app with:
/// - Clean, modern design with rounded corners
/// - Proper focus states with blue accent
/// - Error states with red styling
/// - Support for various input types (text, email, password, etc.)
/// - Built-in validation and error display
/// - Icon support (leading and trailing)
/// - Customizable styling while maintaining consistency
///
/// Usage examples:
/// ```dart
/// // Basic text field
/// ThemeTextField(
///   label: 'Full Name',
///   onChanged: (value) => print('Name: $value'),
/// )
///
/// // Email field with validation
/// ThemeTextField(
///   label: 'Email',
///   inputType: TextInputType.emailAddress,
///   validator: (value) {
///     if (value?.isEmpty ?? true) return 'Email is required';
///     if (!value!.contains('@')) return 'Invalid email format';
///     return null;
///   },
/// )
///
/// // Password field with toggle
/// ThemeTextField(
///   label: 'Password',
///   isPassword: true,
///   validator: (value) {
///     if (value?.isEmpty ?? true) return 'Password is required';
///     if (value!.length < 6) return 'Password too short';
///     return null;
///   },
/// )
/// ```
class ThemeTextField extends StatefulWidget {
  /// The label text to display above the field
  final String label;

  /// Optional hint text to display inside the field
  final String? hint;

  /// The text editing controller
  final TextEditingController? controller;

  /// Callback when the text changes
  final ValueChanged<String>? onChanged;

  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Validation function
  final String? Function(String?)? validator;

  /// The type of keyboard to show
  final TextInputType? inputType;

  /// Whether this is a password field
  final bool isPassword;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Maximum number of lines for the field
  final int? maxLines;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// Leading icon to display
  final IconData? leadingIcon;

  /// Trailing icon to display (ignored if isPassword is true)
  final IconData? trailingIcon;

  /// Trailing buttonx
  final Widget? trailingWidget;

  /// Custom text style for the input text
  final TextStyle? textStyle;

  /// Custom text style for the label
  final TextStyle? labelStyle;

  /// Custom text style for the hint
  final TextStyle? hintStyle;

  /// Custom text style for error messages
  final TextStyle? errorStyle;

  /// Whether to show the character counter
  final bool showCounter;

  /// Input formatters for the field
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to automatically validate on change
  final bool autoValidate;

  /// Focus node for the field
  final FocusNode? focusNode;

  const ThemeTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputType,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingWidget,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.showCounter = false,
    this.inputFormatters,
    this.autoValidate = false,
    this.focusNode,
  });

  @override
  State<ThemeTextField> createState() => _ThemeTextFieldState();
}

class _ThemeTextFieldState extends State<ThemeTextField> {
  bool _obscureText = true;
  bool _hasFocus = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.autoValidate && widget.validator != null) {
      widget.controller?.addListener(_validateField);
    }
  }

  @override
  void dispose() {
    if (widget.autoValidate && widget.validator != null) {
      widget.controller?.removeListener(_validateField);
    }
    super.dispose();
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller?.text);
      if (mounted) {
        setState(() {
          _errorText = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style:
          widget.labelStyle ??
              ThemeFonts.text14Bold(textColor: _hasFocus ? ThemeColors.themeBlue : ThemeColors.primaryBlack),
        ),
        const SizedBox(height: 8),

        // Text Field
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _hasFocus = hasFocus;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: (value) {
              widget.onChanged?.call(value);
              if (widget.autoValidate) {
                _validateField();
              }
            },
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            keyboardType: widget.inputType,
            obscureText: widget.isPassword && _obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            style:
            widget.textStyle ??
                ThemeFonts.text16(textColor: widget.enabled ? ThemeColors.primaryBlack : ThemeColors.midGrey),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? ThemeFonts.text16(textColor: ThemeColors.midGrey),
              prefixIcon:
              widget.leadingIcon != null ? Icon(widget.leadingIcon, color: _getIconColor(), size: 20) : null,
              suffixIcon: _buildSuffixIcon(),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              counterText: widget.showCounter ? null : '',
              filled: true,
              fillColor: widget.enabled ? ThemeColors.white : ThemeColors.primarySand,
              border: _buildBorder(),
              enabledBorder: _buildBorder(),
              focusedBorder: _buildBorder(isFocused: true),
              errorBorder: _buildBorder(isError: true),
              focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
              disabledBorder: _buildBorder(isDisabled: true),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorStyle: widget.errorStyle ?? ThemeFonts.text12(textColor: ThemeColors.notificationRed),
            ),
          ),
        ),

        // Error message
        if (_errorText != null || (widget.validator != null && widget.autoValidate)) ...[
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _errorText != null ? null : 0,
            child:
            _errorText != null
                ? Text(
              _errorText!,
              style: widget.errorStyle ?? ThemeFonts.text12(textColor: ThemeColors.notificationRed),
            )
                : null,
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: _getIconColor(), size: 20),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.trailingIcon != null) {
      return Icon(widget.trailingIcon, color: _getIconColor(), size: 20);
    }

    if (widget.trailingWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: widget.trailingWidget,
      );
    }

    return null;
  }

  Color _getIconColor() {
    if (!widget.enabled) {
      return ThemeColors.midGrey;
    }

    if (_hasFocus) {
      return ThemeColors.themeBlue;
    }

    if (_errorText != null) {
      return ThemeColors.notificationRed;
    }

    return ThemeColors.midGrey;
  }

  OutlineInputBorder _buildBorder({bool isFocused = false, bool isError = false, bool isDisabled = false}) {
    Color borderColor;
    double borderWidth = 1.0;

    if (isDisabled) {
      borderColor = ThemeColors.lightGrey;
    } else if (isError) {
      borderColor = ThemeColors.notificationRed;
      borderWidth = 1.5;
    } else if (isFocused) {
      borderColor = ThemeColors.themeBlue;
      borderWidth = 1.5;
    } else {
      borderColor = ThemeColors.lightGrey;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

/// A specialized email text field with built-in email validation.
class ThemeEmailField extends StatelessWidget {
  /// The label text to display above the field
  final String label;

  /// Optional hint text to display inside the field
  final String? hint;

  /// The text editing controller
  final TextEditingController? controller;

  /// Callback when the text changes
  final ValueChanged<String>? onChanged;

  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether to automatically validate on change
  final bool autoValidate;

  /// Focus node for the field
  final FocusNode? focusNode;

  const ThemeEmailField({
    super.key,
    this.label = 'Email',
    this.hint = 'Enter your email',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autoValidate = true,
    this.focusNode,
  });

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Basic email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: _validateEmail,
      inputType: TextInputType.emailAddress,
      leadingIcon: Icons.email_outlined,
      enabled: enabled,
      readOnly: readOnly,
      autoValidate: autoValidate,
      focusNode: focusNode,
    );
  }
}

/// A specialized password text field with built-in validation.
class ThemePasswordField extends StatelessWidget {
  /// The label text to display above the field
  final String label;

  /// Optional hint text to display inside the field
  final String? hint;

  /// The text editing controller
  final TextEditingController? controller;

  /// Callback when the text changes
  final ValueChanged<String>? onChanged;

  /// Callback when the field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Minimum password length
  final int minLength;

  /// Whether to automatically validate on change
  final bool autoValidate;

  /// Focus node for the field
  final FocusNode? focusNode;

  const ThemePasswordField({
    super.key,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.minLength = 6,
    this.autoValidate = true,
    this.focusNode,
  });

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: _validatePassword,
      isPassword: true,
      leadingIcon: Icons.lock_outlined,
      enabled: enabled,
      readOnly: readOnly,
      autoValidate: autoValidate,
      focusNode: focusNode,
    );
  }
}

/// A specialized name text field with validation.
class ThemeNameField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool autoValidate;
  final FocusNode? focusNode;

  const ThemeNameField({
    super.key,
    this.label = 'Name',
    this.hint = 'Enter name',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autoValidate = true,
    this.focusNode,
  });

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Enter a valid name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: _validateName,
      inputType: TextInputType.name,
      enabled: enabled,
      readOnly: readOnly,
      autoValidate: autoValidate,
      focusNode: focusNode,
    );
  }
}

/// A specialized text field with a suffix "Add" action.
class ThemeAddressField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onAddTap;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeAddressField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onAddTap,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: 'Enter Address',
      hint: 'Enter Here',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Address is required';
        }
        return null;
      },
      trailingWidget: InkWell(
        onTap: onAddTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            "Add",
            style: ThemeFonts.text14Bold(textColor: ThemeColors.themeBlue),
          ),
        ),
      ),
    );
  }
}

class ThemeAddressField2 extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onAddTap;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeAddressField2({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onAddTap,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: label ?? 'Enter Address',
      hint: hint ?? 'Enter Here',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Address is required';
        }
        return null;
      },
    );
  }
}

/// Country field (optional)
class ThemeCountryField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeCountryField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "Country",
      hint: "Enter country",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.text,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Country is required';
        }
        return null;
      },
    );
  }
}

/// State field (optional)
class ThemeStateField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeStateField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "State",
      hint: "Enter state",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.text,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

/// City field (optional)
class ThemeCityField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeCityField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "City",
      hint: "Enter city",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.text,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

/// Area field (optional)
class ThemeAreaField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeAreaField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "Area",
      hint: "Enter area",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.text,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

/// Pincode field (optional, numeric input)
class ThemePincodeField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemePincodeField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "Pincode",
      hint: "Enter pincode",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.number,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Pincode is required';
        } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
          return 'Enter a valid 6-digit pincode';
        }
        return null;
      },
    );
  }
}

/// Company Name field (optional)
class ThemeCompanyNameField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeCompanyNameField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "Company Name",
      hint: "Enter company name",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.text,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
    );
  }
}

/// A plain text field with validation (no prefix/suffix icons).
class ThemeNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeNumberField({
    super.key,
    required this.controller,
    this.label = 'Number',
    this.hint = 'Enter number',
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ThemeFonts.text14Bold(
            textColor: ThemeColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          // ✅ Built-in validation logic
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Number is required';
            } else if (value.length < 10) {
              return 'Enter a valid 10-digit number';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Only digits allowed';
            }
            return null; // ✅ valid case
          },
          style: ThemeFonts.text16(textColor: ThemeColors.primaryBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: ThemeFonts.text16(textColor: ThemeColors.midGrey),
            filled: true,
            fillColor: ThemeColors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

/// Plain Email Field
class ThemePlainEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final bool requiredField; // make field required
  final bool validateEmail; // validate email format

  const ThemePlainEmailField({
    super.key,
    required this.controller,
    this.label = 'Email',
    this.hint = 'Enter email',
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.requiredField = true,   // default to required
    this.validateEmail = true,   // default to validate format
  });

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? ThemeColors.lightGrey,
        width: width,
      ),
    );
  }

  String? _validator(String? value) {
    if (requiredField && (value == null || value.trim().isEmpty)) {
      return 'Email is required';
    }
    if (validateEmail && value != null && value.trim().isNotEmpty) {
      final emailRegex =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Enter a valid email';
      }
    }
    return null; // ✅ valid
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ThemeFonts.text14Bold(
            textColor: ThemeColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: ThemeFonts.text16(textColor: ThemeColors.primaryBlack),
          validator: _validator, // ✅ validation applied here
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: ThemeFonts.text16(textColor: ThemeColors.midGrey),
            filled: true,
            fillColor: ThemeColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(color: ThemeColors.lightGrey),
            focusedBorder: _buildBorder(color: ThemeColors.themeBlue, width: 1.5),
            errorBorder: _buildBorder(color: ThemeColors.notificationRed, width: 1.5),
            focusedErrorBorder: _buildBorder(color: ThemeColors.themeBlue, width: 1.5),
          ),
        ),
      ],
    );
  }
}

/// A specialized WhatsApp number text field (no validation).
class ThemeWhatsAppField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeWhatsAppField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextField(
      label: "WhatsApp Number",
      hint: "Enter WhatsApp number",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only digits allowed
      ],
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
    );
  }
}


class IndustryPickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> industries;
  final TextStyle? labelStyle;

  const IndustryPickerField({
    Key? key,
    required this.controller,
    required this.label,
    this.industries = const [
      "Hardware",
      "Software",
      "Manufacturing",
      "Healthcare",
      "Education",
    ],
    this.labelStyle,
  }) : super(key: key);

  Future<void> _pickIndustry(BuildContext context) async {
    final selectedIndustry = await showDialog<String>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: ThemeColors.white,
          title: Text(
            'Select Industry',
            style: ThemeFonts.text14Bold(
              textColor: ThemeColors.primaryBlack,
            ),
          ),
          children: industries
              .map(
                (industry) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, industry),
              child: Text(
                industry,
                style: ThemeFonts.text14(
                  textColor: ThemeColors.primaryBlack,
                ),
              ),
            ),
          )
              .toList(),
        );
      },
    );

    if (selectedIndustry != null) {
      controller.text = selectedIndustry;
    }
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? ThemeColors.lightGrey,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: labelStyle ??
              ThemeFonts.text14Bold(
                textColor: ThemeColors.primaryBlack,
              ),
        ),
        const SizedBox(height: 8),

        // Read-only TextField
        TextFormField(
          controller: controller,
          readOnly: true,
          showCursor: false,
          onTap: () => _pickIndustry(context),
          style: ThemeFonts.text16(
            textColor: ThemeColors.primaryBlack,
          ),
          decoration: InputDecoration(
            hintText: "Select Industry",
            hintStyle: ThemeFonts.text16(
              textColor: ThemeColors.midGrey,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: ThemeColors.midGrey,
            ),
            filled: true,
            fillColor: ThemeColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(color: ThemeColors.lightGrey),
            focusedBorder: _buildBorder(
              color: ThemeColors.themeBlue,
              width: 1.5,
            ),
            errorBorder: _buildBorder(
              color: ThemeColors.notificationRed,
              width: 1.5,
            ),
            focusedErrorBorder: _buildBorder(
              color: ThemeColors.themeBlue,
              width: 1.5,
            ),
            disabledBorder: _buildBorder(color: ThemeColors.lightGrey),
          ),
        ),
      ],
    );
  }
}

/// Visit Start/End Location Field
class ThemeVisitLocationField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const ThemeVisitLocationField({
    super.key,
    this.controller,
    this.label = 'Visit Location',
    this.hint = 'Enter location',
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color ?? ThemeColors.lightGrey, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: ThemeFonts.text16(textColor: ThemeColors.primaryBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: ThemeFonts.text16(textColor: ThemeColors.midGrey),
            filled: true,
            fillColor: ThemeColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: _buildBorder(),
            enabledBorder: _buildBorder(color: ThemeColors.lightGrey),
            focusedBorder: _buildBorder(color: ThemeColors.themeBlue, width: 1.5),
            errorBorder: _buildBorder(color: ThemeColors.notificationRed, width: 1.5),
            focusedErrorBorder: _buildBorder(color: ThemeColors.themeBlue, width: 1.5),
          ),
        ),
      ],
    );
  }
}

class SourcePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> sources;
  final TextStyle? labelStyle;

  const SourcePickerField({
    Key? key,
    required this.controller,
    this.label = "Source",
    this.sources = const [
      "Internet",
      "Website",
    ],
    this.labelStyle,
  }) : super(key: key);

  Future<void> _pickSource(BuildContext context) async {
    final selectedSource = await showDialog<String>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: ThemeColors.white,
          title: Text(
            'Select Source',
            style: ThemeFonts.text14Bold(
              textColor: ThemeColors.primaryBlack,
            ),
          ),
          children: sources
              .map(
                (source) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, source),
              child: Text(
                source,
                style: ThemeFonts.text14(
                  textColor: ThemeColors.primaryBlack,
                ),
              ),
            ),
          )
              .toList(),
        );
      },
    );

    if (selectedSource != null) {
      controller.text = selectedSource;
    }
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? ThemeColors.lightGrey,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: labelStyle ??
              ThemeFonts.text14Bold(
                textColor: ThemeColors.primaryBlack,
              ),
        ),
        const SizedBox(height: 8),

        // Read-only TextField
        TextFormField(
          controller: controller,
          readOnly: true,
          showCursor: false,
          onTap: () => _pickSource(context),
          style: ThemeFonts.text16(
            textColor: ThemeColors.primaryBlack,
          ),
          decoration: InputDecoration(
            hintText: "Select Source",
            hintStyle: ThemeFonts.text16(
              textColor: ThemeColors.midGrey,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: ThemeColors.midGrey,
            ),
            filled: true,
            fillColor: ThemeColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(color: ThemeColors.lightGrey),
            focusedBorder: _buildBorder(
              color: ThemeColors.themeBlue,
              width: 1.5,
            ),
            errorBorder: _buildBorder(
              color: ThemeColors.notificationRed,
              width: 1.5,
            ),
            focusedErrorBorder: _buildBorder(
              color: ThemeColors.themeBlue,
              width: 1.5,
            ),
            disabledBorder: _buildBorder(color: ThemeColors.lightGrey),
          ),
        ),
      ],
    );
  }
}
