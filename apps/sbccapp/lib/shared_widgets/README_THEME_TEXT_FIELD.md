# ThemeTextField Component

A reusable text field component that follows the SBCC design system for consistent styling across the app.

## Features

- **Consistent Design**: Follows the app's design system with proper colors, typography, and spacing
- **Modern Styling**: Clean, rounded corners with proper focus and error states
- **Built-in Validation**: Support for custom validation with real-time feedback
- **Specialized Fields**: Pre-built email and password fields with built-in validation
- **Icon Support**: Leading and trailing icons for better UX
- **Accessibility**: Proper focus management and screen reader support
- **Customizable**: Flexible styling options while maintaining consistency

## Design Specifications

- **Border Radius**: 12px rounded corners
- **Border Colors**:
  - Normal: `ThemeColors.lightGrey`
  - Focused: `ThemeColors.bluePolynesian` (1.5px width)
  - Error: `ThemeColors.notificationRed` (1.5px width)
  - Disabled: `ThemeColors.lightGrey`
- **Background**: `ThemeColors.white` (enabled), `ThemeColors.primarySand` (disabled)
- **Typography**: `ThemeFonts.text16` for input, `ThemeFonts.text14Bold` for labels
- **Padding**: 16px horizontal, 16px vertical
- **Icon Size**: 20px

## Component Variants

### ThemeTextField (Base Component)

The main text field component with full customization options.

### ThemeEmailField

Specialized email field with built-in email validation.

### ThemePasswordField

Specialized password field with built-in validation and show/hide toggle.

## Usage

### Basic Text Field

```dart
import 'package:sbccapp/shared_widgets/theme_text_field.dart';

ThemeTextField(
  label: 'Full Name',
  hint: 'Enter your full name',
  onChanged: (value) => print('Name: $value'),
)
```

### Email Field

```dart
ThemeEmailField(
  controller: emailController,
  onChanged: (value) => print('Email: $value'),
)
```

### Password Field

```dart
ThemePasswordField(
  controller: passwordController,
  minLength: 8,
  onChanged: (value) => print('Password: $value'),
)
```

### With Validation

```dart
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
)
```

### With Icons

```dart
ThemeTextField(
  label: 'Phone Number',
  hint: 'Enter your phone number',
  leadingIcon: Icons.phone_outlined,
  trailingIcon: Icons.info_outline,
  inputType: TextInputType.phone,
)
```

### Multi-line Field

```dart
ThemeTextField(
  label: 'Address',
  hint: 'Enter your address',
  maxLines: 3,
  leadingIcon: Icons.location_on_outlined,
)
```

## Props Reference

### ThemeTextField

| Prop              | Type                         | Required | Default | Description                      |
| ----------------- | ---------------------------- | -------- | ------- | -------------------------------- |
| `label`           | `String`                     | ✅       | -       | Label text above the field       |
| `hint`            | `String?`                    | ❌       | `null`  | Hint text inside the field       |
| `controller`      | `TextEditingController?`     | ❌       | `null`  | Text editing controller          |
| `onChanged`       | `ValueChanged<String>?`      | ❌       | `null`  | Callback when text changes       |
| `onSubmitted`     | `ValueChanged<String>?`      | ❌       | `null`  | Callback when field is submitted |
| `validator`       | `String? Function(String?)?` | ❌       | `null`  | Validation function              |
| `inputType`       | `TextInputType?`             | ❌       | `null`  | Keyboard type                    |
| `isPassword`      | `bool`                       | ❌       | `false` | Whether this is a password field |
| `enabled`         | `bool`                       | ❌       | `true`  | Whether the field is enabled     |
| `readOnly`        | `bool`                       | ❌       | `false` | Whether the field is read-only   |
| `maxLines`        | `int?`                       | ❌       | `1`     | Maximum number of lines          |
| `maxLength`       | `int?`                       | ❌       | `null`  | Maximum character count          |
| `leadingIcon`     | `IconData?`                  | ❌       | `null`  | Icon before the text             |
| `trailingIcon`    | `IconData?`                  | ❌       | `null`  | Icon after the text              |
| `textStyle`       | `TextStyle?`                 | ❌       | `null`  | Custom text style                |
| `labelStyle`      | `TextStyle?`                 | ❌       | `null`  | Custom label style               |
| `hintStyle`       | `TextStyle?`                 | ❌       | `null`  | Custom hint style                |
| `errorStyle`      | `TextStyle?`                 | ❌       | `null`  | Custom error style               |
| `showCounter`     | `bool`                       | ❌       | `false` | Show character counter           |
| `inputFormatters` | `List<TextInputFormatter>?`  | ❌       | `null`  | Input formatters                 |
| `autoValidate`    | `bool`                       | ❌       | `false` | Auto-validate on change          |
| `focusNode`       | `FocusNode?`                 | ❌       | `null`  | Focus node                       |

### ThemeEmailField

| Prop           | Type                     | Required | Default              | Description                |
| -------------- | ------------------------ | -------- | -------------------- | -------------------------- |
| `label`        | `String`                 | ❌       | `'Email'`            | Label text                 |
| `hint`         | `String`                 | ❌       | `'Enter your email'` | Hint text                  |
| `controller`   | `TextEditingController?` | ❌       | `null`               | Text editing controller    |
| `onChanged`    | `ValueChanged<String>?`  | ❌       | `null`               | Callback when text changes |
| `onSubmitted`  | `ValueChanged<String>?`  | ❌       | `null`               | Callback when submitted    |
| `enabled`      | `bool`                   | ❌       | `true`               | Whether enabled            |
| `readOnly`     | `bool`                   | ❌       | `false`              | Whether read-only          |
| `autoValidate` | `bool`                   | ❌       | `true`               | Auto-validate on change    |
| `focusNode`    | `FocusNode?`             | ❌       | `null`               | Focus node                 |

### ThemePasswordField

| Prop           | Type                     | Required | Default                 | Description                |
| -------------- | ------------------------ | -------- | ----------------------- | -------------------------- |
| `label`        | `String`                 | ❌       | `'Password'`            | Label text                 |
| `hint`         | `String`                 | ❌       | `'Enter your password'` | Hint text                  |
| `controller`   | `TextEditingController?` | ❌       | `null`                  | Text editing controller    |
| `onChanged`    | `ValueChanged<String>?`  | ❌       | `null`                  | Callback when text changes |
| `onSubmitted`  | `ValueChanged<String>?`  | ❌       | `null`                  | Callback when submitted    |
| `enabled`      | `bool`                   | ❌       | `true`                  | Whether enabled            |
| `readOnly`     | `bool`                   | ❌       | `false`                 | Whether read-only          |
| `minLength`    | `int`                    | ❌       | `6`                     | Minimum password length    |
| `autoValidate` | `bool`                   | ❌       | `true`                  | Auto-validate on change    |
| `focusNode`    | `FocusNode?`             | ❌       | `null`                  | Focus node                 |

## Best Practices

### 1. Label Text

- Use clear, descriptive labels
- Keep labels concise but informative
- Use sentence case (first letter capitalized)

### 2. Hint Text

- Provide helpful guidance without being verbose
- Use action-oriented language: "Enter your..." or "Type your..."
- Keep hints under 50 characters when possible

### 3. Validation

- Provide immediate feedback with `autoValidate: true`
- Use clear, actionable error messages
- Validate on both change and submit

### 4. Icons

- Use leading icons for field type identification
- Use trailing icons sparingly for additional actions
- Choose semantically appropriate icons
- Maintain consistent icon sizes

### 5. Accessibility

- Always provide meaningful labels
- Use appropriate input types for keyboard optimization
- Test with screen readers
- Ensure sufficient color contrast

## Common Patterns

### Form Validation

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      ThemeTextField(
        label: 'Name',
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Name is required';
          return null;
        },
      ),
      ThemeButton(
        text: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid
          }
        },
      ),
    ],
  ),
)
```

### Input Formatting

```dart
ThemeTextField(
  label: 'Phone Number',
  inputType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  leadingIcon: Icons.phone_outlined,
)
```

### Character Limits

```dart
ThemeTextField(
  label: 'Description',
  maxLength: 200,
  showCounter: true,
  maxLines: 3,
)
```

### Conditional Validation

```dart
ThemeTextField(
  label: 'Optional Field',
  validator: (value) {
    if (value?.isNotEmpty ?? false) {
      if (value!.length < 3) {
        return 'Must be at least 3 characters if provided';
      }
    }
    return null;
  },
)
```

## Migration Guide

When replacing existing TextFormField widgets:

### 1. Replace Basic TextFormField

```dart
// Old
TextFormField(
  decoration: InputDecoration(
    labelText: 'Name',
    border: OutlineInputBorder(),
  ),
)

// New
ThemeTextField(
  label: 'Name',
)
```

### 2. Replace Email Field

```dart
// Old
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email required';
    if (!value!.contains('@')) return 'Invalid email';
    return null;
  },
)

// New
ThemeEmailField()
```

### 3. Replace Password Field

```dart
// Old
TextFormField(
  decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
  ),
  obscureText: true,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Password required';
    return null;
  },
)

// New
ThemePasswordField()
```

## Testing

To test the ThemeTextField components, you can use the `ThemeTextFieldExamples` page:

```dart
// Navigate to the examples page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ThemeTextFieldExamples(),
  ),
)
```

## Troubleshooting

### Field not responding to input

- Check if `enabled` is true
- Verify `readOnly` is false
- Ensure controller is properly initialized

### Validation not working

- Make sure `validator` function is provided
- Check if `autoValidate` is true for real-time validation
- Verify form has a `GlobalKey<FormState>`

### Styling issues

- Don't override the built-in styling unless necessary
- Use the design system colors for consistency
- Check if custom styles conflict with theme styles

### Performance issues

- Avoid creating controllers in build methods
- Use `const` constructors when possible
- Dispose controllers properly in dispose methods
