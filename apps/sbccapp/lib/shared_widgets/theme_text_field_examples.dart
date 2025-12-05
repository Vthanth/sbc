import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design_system/src/theme_colors.dart';
import '../core/design_system/src/theme_fonts.dart';
import 'theme_text_field.dart';

/// Example page demonstrating various ThemeTextField usage patterns.
///
/// This file serves as both documentation and a testing ground for the ThemeTextField components.
/// You can use this as a reference when implementing text fields throughout the app.
class ThemeTextFieldExamples extends StatefulWidget {
  const ThemeTextFieldExamples({super.key});

  @override
  State<ThemeTextFieldExamples> createState() => _ThemeTextFieldExamplesState();
}

class _ThemeTextFieldExamplesState extends State<ThemeTextFieldExamples> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThemeTextField Examples'),
        backgroundColor: ThemeColors.themeBlue,
        foregroundColor: ThemeColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Basic Text Fields',
                description: 'Standard text fields with different configurations',
                children: [
                  ThemeTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    leadingIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    controller: _phoneController,
                    inputType: TextInputType.phone,
                    leadingIcon: Icons.phone_outlined,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Address',
                    hint: 'Enter your address',
                    controller: _addressController,
                    leadingIcon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),
                ],
              ),

              _buildSection(
                title: 'Specialized Fields',
                description: 'Pre-built fields for common use cases',
                children: [
                  ThemeEmailField(controller: _emailController),
                  const SizedBox(height: 20),
                  ThemePasswordField(controller: _passwordController, minLength: 8),
                ],
              ),

              _buildSection(
                title: 'Validation Examples',
                description: 'Fields with different validation rules',
                children: [
                  ThemeTextField(
                    label: 'Required Field',
                    hint: 'This field is required',
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    autoValidate: true,
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Minimum Length',
                    hint: 'At least 5 characters',
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Field is required';
                      }
                      if (value!.length < 5) {
                        return 'Must be at least 5 characters';
                      }
                      return null;
                    },
                    autoValidate: true,
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Numeric Only',
                    hint: 'Enter numbers only',
                    inputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a number';
                      }
                      if (int.tryParse(value!) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    autoValidate: true,
                  ),
                ],
              ),

              _buildSection(
                title: 'Custom Styling',
                description: 'Fields with custom styling options',
                children: [
                  ThemeTextField(
                    label: 'Custom Label Style',
                    hint: 'Custom styled field',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.themeBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'With Trailing Icon',
                    hint: 'Field with trailing icon',
                    trailingIcon: Icons.info_outline,
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Character Counter',
                    hint: 'Limited to 50 characters',
                    maxLength: 50,
                    showCounter: true,
                  ),
                ],
              ),

              _buildSection(
                title: 'Disabled & Read-only',
                description: 'Fields in different states',
                children: [
                  ThemeTextField(
                    label: 'Disabled Field',
                    hint: 'This field is disabled',
                    enabled: false,
                    controller: TextEditingController(text: 'Disabled value'),
                  ),
                  const SizedBox(height: 20),
                  ThemeTextField(
                    label: 'Read-only Field',
                    hint: 'This field is read-only',
                    readOnly: true,
                    controller: TextEditingController(text: 'Read-only value'),
                  ),
                ],
              ),

              _buildSection(
                title: 'Form Example',
                description: 'Complete form with validation',
                children: [
                  ThemeTextField(
                    label: 'Notes',
                    hint: 'Enter any additional notes',
                    controller: _notesController,
                    maxLines: 4,
                    leadingIcon: Icons.note_outlined,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showSnackBar('Form is valid!');
                        } else {
                          _showSnackBar('Please fix the errors');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.themeBlue,
                        foregroundColor: ThemeColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Validate Form'),
                    ),
                  ),
                ],
              ),

              _buildSection(
                title: 'Real-world Examples',
                description: 'Common field patterns used in the app',
                children: [
                  // User registration form
                  _buildRegistrationForm(),
                  const SizedBox(height: 32),

                  // Contact form
                  _buildContactForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Registration', style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack)),
        const SizedBox(height: 16),
        ThemeTextField(
          label: 'First Name',
          hint: 'Enter your first name',
          leadingIcon: Icons.person_outline,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'First name is required';
            return null;
          },
        ),
        const SizedBox(height: 16),
        ThemeTextField(
          label: 'Last Name',
          hint: 'Enter your last name',
          leadingIcon: Icons.person_outline,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Last name is required';
            return null;
          },
        ),
        const SizedBox(height: 16),
        ThemeEmailField(),
        const SizedBox(height: 16),
        ThemePasswordField(minLength: 8),
      ],
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack)),
        const SizedBox(height: 16),
        ThemeTextField(label: 'Company Name', hint: 'Enter your company name', leadingIcon: Icons.business_outlined),
        const SizedBox(height: 16),
        ThemeTextField(
          label: 'Phone Number',
          hint: 'Enter your phone number',
          inputType: TextInputType.phone,
          leadingIcon: Icons.phone_outlined,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        ThemeTextField(label: 'Message', hint: 'Enter your message', maxLines: 4, leadingIcon: Icons.message_outlined),
      ],
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
}
