import 'package:flutter/material.dart';

const _emojiIOSFontFamily = 'Apple Color Emoji';
const _emojiAndroidFontFamily = 'Noto Color Emoji';

class AppTheme extends StatefulWidget {
  static const emojiIOSFontFamily = _emojiIOSFontFamily;
  static const emojiAndroidFontFamily = _emojiAndroidFontFamily;

  final Widget child;
  final ThemeMode? overriddenThemeMode;
  final bool changeStatusBarColor;

  const AppTheme({super.key, required this.child, this.overriddenThemeMode, this.changeStatusBarColor = false});

  @override
  State<StatefulWidget> createState() {
    return AppThemeState();
  }

  static AppThemeState of(BuildContext context) {
    final inheritedStateContainer = context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    if (inheritedStateContainer == null) {
      return AppThemeState();
    } else {
      // temporary solution
      return inheritedStateContainer.data;
    }
  }
}

class AppThemeState extends State<AppTheme> {
  // ignore: unused_field
  final ThemeMode _themeData = ThemeMode.light;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_element
  Color _themeColor({required Color lightColor, required Color darkColor}) {
    return lightColor;
    //return AdaptiveChameleonTheme.of(context).themeMode == ThemeMode.dark ? darkColor : lightColor;
  }

  //Brightness get primaryColorBrightness => isNightMode ? Brightness.dark : Brightness.light;

  String? get currentPackageName => null;

  //Color get background => isNightMode ? black : white;

  Color get lightBackground => const Color(0xFFF8F8F8);

  Color get edge => const Color(0xFFECECEC);

  Color get white => Colors.white;

  Color get black => Colors.black;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(data: this, child: widget.child);
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppThemeState data;

  const _InheritedStateContainer({required this.data, required super.child});

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
