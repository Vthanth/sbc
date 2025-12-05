# ThemeButton Component

A reusable Call-to-Action (CTA) button component designed for consistent styling across the SBCC app.

## Features

- **Consistent Design**: Follows the app's design system with bluePolynesian background and white text
- **Fixed Height**: 50px height for standard buttons, 40px for small variants
- **Rounded Corners**: 12px border radius by default (customizable)
- **Loading States**: Built-in loading indicator support
- **Icon Support**: Optional leading and trailing icons
- **Responsive**: Adapts to different screen sizes and layouts
- **Accessible**: Proper touch targets and visual feedback
- **Customizable**: Flexible styling options while maintaining consistency

## Design Specifications

- **Background Color**: `ThemeColors.bluePolynesian` (#004E9C)
- **Text Color**: `ThemeColors.white`
- **Height**: 50px (standard), 40px (small)
- **Border Radius**: 12px (standard), 8px (small)
- **Typography**: `ThemeFonts.text16Bold` (standard), `ThemeFonts.text14Bold` (small)
- **Shadow**: Subtle elevation shadow for enabled state
- **Disabled State**: `ThemeColors.midGrey` background

## Usage

### Basic Usage

```dart
import 'package:sbccapp/shared_widgets/theme_button.dart';

ThemeButton(
  text: 'Continue',
  onPressed: () {
    // Handle button press
  },
)
```

### With Icons

```dart
ThemeButton(
  text: 'Add to Cart',
  onPressed: () => addToCart(),
  leadingIcon: Icons.shopping_cart,
)

ThemeButton(
  text: 'Download',
  onPressed: () => downloadFile(),
  trailingIcon: Icons.download,
)
```

### Loading State

```dart
ThemeButton(
  text: 'Processing...',
  onPressed: isLoading ? null : processData,
  isLoading: isLoading,
)
```

### Custom Width

```dart
ThemeButton(
  text: 'Fixed Width',
  onPressed: () => handlePress(),
  width: 200,
)
```

### Small Variant

```dart
ThemeButtonSmall(
  text: 'Edit',
  onPressed: () => editItem(),
  leadingIcon: Icons.edit,
)
```

### Disabled State

```dart
ThemeButton(
  text: 'Submit',
  onPressed: null, // This makes the button disabled
)
```

## Component Variants

### ThemeButton (Standard)

- Height: 50px
- Border radius: 12px
- Typography: `ThemeFonts.text16Bold`
- Padding: 24px horizontal
- Icon size: 18px

### ThemeButtonSmall

- Height: 40px
- Border radius: 8px
- Typography: `ThemeFonts.text14Bold`
- Padding: 16px horizontal
- Icon size: 16px

## Props Reference

### ThemeButton & ThemeButtonSmall

| Prop           | Type            | Required | Default        | Description                      |
| -------------- | --------------- | -------- | -------------- | -------------------------------- |
| `text`         | `String`        | ✅       | -              | Button text to display           |
| `onPressed`    | `VoidCallback?` | ✅       | -              | Callback when button is pressed  |
| `width`        | `double?`       | ❌       | `null`         | Custom width (null = full width) |
| `isLoading`    | `bool`          | ❌       | `false`        | Show loading indicator           |
| `leadingIcon`  | `IconData?`     | ❌       | `null`         | Icon before text                 |
| `trailingIcon` | `IconData?`     | ❌       | `null`         | Icon after text                  |
| `textStyle`    | `TextStyle?`    | ❌       | `null`         | Custom text style override       |
| `showShadow`   | `bool`          | ❌       | `true`         | Show elevation shadow            |
| `borderRadius` | `double`        | ❌       | `12.0` / `8.0` | Custom border radius             |

## Best Practices

### 1. Button Text

- Use action-oriented verbs: "Continue", "Submit", "Save"
- Keep text concise and clear
- Use sentence case (first letter capitalized)

### 2. Icon Usage

- Use leading icons for primary actions
- Use trailing icons for navigation/forward actions
- Choose semantically appropriate icons
- Maintain consistent icon sizes

### 3. Loading States

- Always disable the button during loading
- Use descriptive text like "Processing..." or "Uploading..."
- Show loading indicator for operations > 500ms

### 4. Layout

- Use full-width buttons for primary actions
- Use fixed-width buttons for secondary actions
- Maintain consistent spacing between buttons
- Group related buttons in rows when appropriate

### 5. Accessibility

- Ensure sufficient contrast ratios
- Provide meaningful button text
- Use appropriate touch target sizes
- Test with screen readers

## Common Patterns

### Form Submission

```dart
Column(
  children: [
    // Form fields...
    const SizedBox(height: 24),
    ThemeButton(
      text: 'Submit',
      onPressed: isLoading ? null : submitForm,
      isLoading: isLoading,
    ),
  ],
)
```

### Confirmation Dialogs

```dart
Row(
  children: [
    Expanded(
      child: ThemeButtonSmall(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ThemeButton(
        text: 'Confirm',
        onPressed: () => confirmAction(),
      ),
    ),
  ],
)
```

### Navigation Actions

```dart
ThemeButton(
  text: 'Next',
  onPressed: () => navigateToNext(),
  trailingIcon: Icons.arrow_forward,
)
```

### Data Actions

```dart
ThemeButton(
  text: 'Add Item',
  onPressed: () => addItem(),
  leadingIcon: Icons.add,
)
```

## Testing

To test the ThemeButton component, you can use the `ThemeButtonExamples` page:

```dart
// Navigate to the examples page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ThemeButtonExamples(),
  ),
)
```

## Migration Guide

When replacing existing buttons with ThemeButton:

1. **Replace ElevatedButton**:

   ```dart
   // Old
   ElevatedButton(
     onPressed: onPressed,
     child: Text('Button'),
   )

   // New
   ThemeButton(
     text: 'Button',
     onPressed: onPressed,
   )
   ```

2. **Replace TextButton**:

   ```dart
   // Old
   TextButton(
     onPressed: onPressed,
     child: Text('Button'),
   )

   // New
   ThemeButtonSmall(
     text: 'Button',
     onPressed: onPressed,
   )
   ```

3. **Replace Custom Buttons**:

   ```dart
   // Old
   Container(
     decoration: BoxDecoration(
       color: Colors.blue,
       borderRadius: BorderRadius.circular(12),
     ),
     child: TextButton(...),
   )

   // New
   ThemeButton(
     text: 'Button',
     onPressed: onPressed,
   )
   ```

## Troubleshooting

### Button not responding to taps

- Ensure `onPressed` is not null
- Check if `isLoading` is true
- Verify the button is not covered by other widgets

### Text overflow

- Use shorter button text
- Consider using `ThemeButtonSmall` for longer text
- Use custom `textStyle` with smaller font size

### Inconsistent styling

- Always use ThemeButton instead of custom buttons
- Don't override the background color
- Use the design system colors for text

### Performance issues

- Avoid rebuilding buttons unnecessarily
- Use `const` constructors when possible
- Don't create buttons in build methods without proper keys
