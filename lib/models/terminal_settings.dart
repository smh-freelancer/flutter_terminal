import 'package:flutter/material.dart';

/// User preference settings for the terminal
class TerminalSettings {
  final bool isDarkMode;
  final double fontSize;
  final double lineHeight;
  final String? themeName;
  final Color primaryColor;
  final Color backgroundColor;
  final Color errorColor;
  final Color successColor;

  TerminalSettings({
    this.isDarkMode = true,
    this.fontSize = 14.0,
    this.lineHeight = 1.6,
    this.themeName,
    this.primaryColor = Colors.greenAccent,
    this.backgroundColor = Colors.black,
    this.errorColor = Colors.red,
    this.successColor = Colors.greenAccent,
  });

  /// Create a copy with modified values
  TerminalSettings copyWith({
    bool? isDarkMode,
    double? fontSize,
    double? lineHeight,
    String? themeName,
    Color? primaryColor,
    Color? backgroundColor,
    Color? errorColor,
    Color? successColor,
  }) {
    return TerminalSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      themeName: themeName ?? this.themeName,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerminalSettings &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode &&
          fontSize == other.fontSize &&
          lineHeight == other.lineHeight &&
          themeName == other.themeName &&
          primaryColor == other.primaryColor &&
          backgroundColor == other.backgroundColor &&
          errorColor == other.errorColor &&
          successColor == other.successColor;

  @override
  int get hashCode =>
      isDarkMode.hashCode ^
      fontSize.hashCode ^
      lineHeight.hashCode ^
      themeName.hashCode ^
      primaryColor.hashCode ^
      backgroundColor.hashCode ^
      errorColor.hashCode ^
      successColor.hashCode;
}
