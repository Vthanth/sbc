import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:sbccapp/shared_widgets/break_point.dart';
import 'package:sbccapp/utils.dart';

class UILayout {
  final BuildContext context;

  static const EdgeInsets compactInsets = EdgeInsets.fromLTRB(23, 0, 23, 40);
  static const EdgeInsets regularInsets = EdgeInsets.fromLTRB(32, 0, 32, 25);

  static const EdgeInsets horizontalCompactInsets = EdgeInsets.fromLTRB(23, 0, 23, 0);
  static const EdgeInsets horizontalRegularInsets = EdgeInsets.fromLTRB(32, 0, 32, 0);

  // https://www.figma.com/file/DuWyFp7yYiANLSioZGivpP/Tablet-%F0%9F%A6%8B?node-id=201%3A691
  static final double maxPortraitWidth = 698.0 + regularInsets.horizontal;

  UILayout._(this.context);

  factory UILayout.of(BuildContext context) {
    return UILayout._(context);
  }

  EdgeInsets get contentInset {
    final totalWidth = MediaQuery.of(context).size.width;

    final breakpoint = Breakpoint.fromMediaQuery(context);

    final toolbarWidth = switch (breakpoint.device) {
      LayoutClass.smallHandset => 0,
      LayoutClass.mediumHandset => 0,
      LayoutClass.largeHandset => 0,
      LayoutClass.smallTablet => 0,
      LayoutClass.largeTablet => 0,
      LayoutClass.desktop => 0,
    };

    if (totalWidth > maxPortraitWidth) {
      final addition = (totalWidth - maxPortraitWidth - toolbarWidth) / 2.0;
      return EdgeInsets.symmetric(horizontal: addition > 0 ? addition : 0);
    }

    return EdgeInsets.zero;
  }

  EdgeInsets marginWithMaxWidth({required double maxWidth, double? minMargin, double? customScreenWidth}) {
    final screenWidth = customScreenWidth ?? MediaQuery.of(context).size.width;
    final margin = (screenWidth - maxWidth) / 2.0;
    final defaultMargin = contentPadding;

    return EdgeInsets.only(
      left: max(minMargin ?? defaultMargin.left, margin),
      right: max(minMargin ?? defaultMargin.right, margin),
    );
  }

  EdgeInsets get contentPadding {
    return Utils.isMobileLayout(context) ? compactInsets : regularInsets;
  }

  EdgeInsets get horizontalContentPadding {
    return contentPadding.copyWith(top: 0, bottom: 0);
  }

  EdgeInsets get horizontalContentInset {
    return contentInset.copyWith(top: 0, bottom: 0);
  }

  EdgeInsets get contentInsetAndPadding {
    final inset = contentInset;
    final padding = contentPadding;
    return EdgeInsets.fromLTRB(
      inset.left + padding.left,
      inset.top + padding.top,
      inset.right + padding.right,
      inset.bottom + padding.bottom,
    );
  }

  EdgeInsets get horizontalContentInsetAndPadding {
    return contentInsetAndPadding.copyWith(top: 0, bottom: 0);
  }

  double get screenWidth => MediaQuery.of(context).size.width;
  double get contentWidth => screenWidth - contentInset.horizontal;
  double get contentWidthWithPadding => screenWidth - horizontalContentInsetAndPadding.horizontal;
}
