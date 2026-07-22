import 'package:flutter/material.dart';
import '../models/terminal_settings.dart';

/// Predefined themes for the terminal
abstract class TerminalThemes {
  static final TerminalSettings darkTheme = TerminalSettings(
    isDarkMode: true,
    themeName: 'Dark',
    primaryColor: Colors.greenAccent,
    backgroundColor: Colors.black,
    errorColor: Colors.red,
    successColor: Colors.greenAccent,
  );

  static final TerminalSettings lightTheme = TerminalSettings(
    isDarkMode: false,
    themeName: 'Light',
    primaryColor: Colors.teal[700]!,
    backgroundColor: Colors.grey[100]!,
    errorColor: Colors.red[700]!,
    successColor: Colors.teal[700]!,
  );

  static final TerminalSettings cyberpunkTheme = TerminalSettings(
    isDarkMode: true,
    themeName: 'Cyberpunk',
    primaryColor: const Color(0xFF00FF88),
    backgroundColor: const Color(0xFF0A0E27),
    errorColor: const Color(0xFFFF006E),
    successColor: const Color(0xFF00FF88),
  );

  static final TerminalSettings vintageTheme = TerminalSettings(
    isDarkMode: true,
    themeName: 'Vintage',
    primaryColor: const Color(0xFFA4C639),
    backgroundColor: const Color(0xFF222222),
    errorColor: const Color(0xFFFF6B6B),
    successColor: const Color(0xFFA4C639),
  );

  static final List<TerminalSettings> allThemes = [
    darkTheme,
    lightTheme,
    cyberpunkTheme,
    vintageTheme,
  ];

  static TerminalSettings getThemeByName(String name) {
    try {
      return allThemes.firstWhere(
        (t) => t.themeName?.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return darkTheme;
    }
  }
}

/// Service for managing terminal themes and settings
class ThemeService extends ChangeNotifier {
  late TerminalSettings _currentSettings;

  ThemeService({TerminalSettings? initialSettings})
    : _currentSettings = initialSettings ?? TerminalThemes.darkTheme;

  TerminalSettings get currentSettings => _currentSettings;

  ThemeData get themeData => _buildThemeData();

  /// Update theme settings
  void updateSettings(TerminalSettings newSettings) {
    _currentSettings = newSettings;
    notifyListeners();
  }

  /// Switch theme by name
  void switchTheme(String themeName) {
    _currentSettings = TerminalThemes.getThemeByName(themeName);
    notifyListeners();
  }

  /// Update font size
  void setFontSize(double size) {
    _currentSettings = _currentSettings.copyWith(fontSize: size);
    notifyListeners();
  }

  /// Update line height
  void setLineHeight(double height) {
    _currentSettings = _currentSettings.copyWith(lineHeight: height);
    notifyListeners();
  }

  /// Toggle dark/light mode
  void toggleDarkMode() {
    final newSettings = _currentSettings.copyWith(
      isDarkMode: !_currentSettings.isDarkMode,
    );
    _currentSettings = newSettings;
    notifyListeners();
  }

  /// Reset to default theme
  void resetToDefault() {
    _currentSettings = TerminalThemes.darkTheme;
    notifyListeners();
  }

  /// Build ThemeData from settings
  ThemeData _buildThemeData() {
    final settings = _currentSettings;

    return ThemeData(
      brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: settings.backgroundColor,
      fontFamily: 'monospace',
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: settings.isDarkMode
            ? Colors.grey[900]
            : Colors.grey[200],
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: settings.primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: settings.primaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: settings.primaryColor,
          fontFamily: 'monospace',
          fontSize: settings.fontSize,
        ),
      ),
    );
  }
}
