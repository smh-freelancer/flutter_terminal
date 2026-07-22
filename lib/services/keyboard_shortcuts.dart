import 'package:flutter/services.dart';

/// Handles keyboard shortcuts for the terminal
class KeyboardShortcutHandler {
  /// Check if Ctrl key is pressed
  static bool isCtrlPressed(KeyEvent event) {
    return HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.control,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlRight,
        );
  }

  /// Check if Shift key is pressed
  static bool isShiftPressed(KeyEvent event) {
    return HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shift,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shiftRight,
        );
  }

  /// Check if Alt/Option key is pressed
  static bool isAltPressed(KeyEvent event) {
    return HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.alt,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altRight,
        );
  }

  /// Check if Meta/Command key is pressed (macOS/Windows)
  static bool isMetaPressed(RawKeyEvent event) {
    return HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.meta,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaRight,
        );
  }

  /// Check if a specific key is pressed
  static bool isKeyPressed(RawKeyEvent event, LogicalKeyboardKey key) {
    return HardwareKeyboard.instance.isLogicalKeyPressed(key);
  }

  /// Get keyboard shortcut description
  static String getShortcutDescription(
    String key, {
    bool ctrl = false,
    bool shift = false,
    bool alt = false,
    bool meta = false,
  }) {
    final parts = <String>[];

    if (ctrl) parts.add('Ctrl');
    if (shift) parts.add('Shift');
    if (alt) parts.add('Alt');
    if (meta) parts.add('Cmd');

    parts.add(key);
    return parts.join(' + ');
  }
}

/// Predefined keyboard shortcuts
abstract class KeyboardShortcuts {
  static const Map<String, String> shortcuts = {
    'clear_screen': 'Ctrl + L',
    'copy': 'Ctrl + C',
    'paste': 'Ctrl + V',
    'select_all': 'Ctrl + A',
    'undo': 'Ctrl + Z',
    'redo': 'Ctrl + Y',
    'find': 'Ctrl + F',
    'help': 'F1',
    'settings': 'Ctrl + ,',
    'zoom_in': 'Ctrl + +',
    'zoom_out': 'Ctrl - -',
    'reset_zoom': 'Ctrl + 0',
    'toggle_theme': 'Ctrl + Shift + T',
    'previous_command': 'Up Arrow',
    'next_command': 'Down Arrow',
    'autocomplete': 'Tab',
  };

  static String? getShortcut(String action) => shortcuts[action];

  static List<String> getAllShortcuts() => shortcuts.keys.toList();
}
