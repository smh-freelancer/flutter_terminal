import 'package:flutter/material.dart';
import '../models/terminal_settings.dart';
import '../services/theme_service.dart';
import '../services/keyboard_shortcuts.dart';

/// Settings panel for terminal customization
class SettingsPanel extends StatefulWidget {
  final ThemeService themeService;
  final VoidCallback onClose;

  const SettingsPanel({
    required this.themeService,
    required this.onClose,
    super.key,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late TerminalSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.themeService.currentSettings;
  }

  void _updateSettings(TerminalSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.themeService.updateSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _settings.backgroundColor,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: _settings.backgroundColor,
          border: Border.all(color: _settings.primaryColor, width: 2),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _settings.primaryColor, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terminal Settings',
                    style: TextStyle(
                      color: _settings.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: _settings.primaryColor),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Selection
                    _buildSectionTitle('Theme'),
                    _buildThemeSelector(),
                    const SizedBox(height: 24),

                    // Font Size
                    _buildSectionTitle('Font Size'),
                    _buildFontSizeSlider(),
                    const SizedBox(height: 24),

                    // Line Height
                    _buildSectionTitle('Line Height'),
                    _buildLineHeightSlider(),
                    const SizedBox(height: 24),

                    // Keyboard Shortcuts
                    _buildSectionTitle('Keyboard Shortcuts'),
                    _buildShortcutsList(),
                    const SizedBox(height: 24),

                    // Reset Button
                    _buildResetButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _settings.primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Wrap(
      spacing: 8,
      children: TerminalThemes.allThemes
          .map(
            (theme) => FilterChip(
              label: Text(theme.themeName ?? 'Unknown'),
              selected: _settings.themeName == theme.themeName,
              selectedColor: _settings.primaryColor,
              labelStyle: TextStyle(
                color: _settings.themeName == theme.themeName
                    ? _settings.backgroundColor
                    : _settings.primaryColor,
                fontFamily: 'monospace',
              ),
              side: BorderSide(color: _settings.primaryColor),
              backgroundColor: _settings.backgroundColor,
              onSelected: (selected) {
                if (selected) {
                  _updateSettings(theme);
                }
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildFontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size: ${_settings.fontSize.toStringAsFixed(1)}',
          style: TextStyle(
            color: _settings.primaryColor,
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
        Slider(
          value: _settings.fontSize,
          min: 10,
          max: 24,
          divisions: 14,
          activeColor: _settings.primaryColor,
          onChanged: (value) {
            _updateSettings(_settings.copyWith(fontSize: value));
          },
        ),
      ],
    );
  }

  Widget _buildLineHeightSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height: ${_settings.lineHeight.toStringAsFixed(1)}',
          style: TextStyle(
            color: _settings.primaryColor,
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
        Slider(
          value: _settings.lineHeight,
          min: 1.0,
          max: 2.5,
          divisions: 15,
          activeColor: _settings.primaryColor,
          onChanged: (value) {
            _updateSettings(_settings.copyWith(lineHeight: value));
          },
        ),
      ],
    );
  }

  Widget _buildShortcutsList() {
    final shortcuts = KeyboardShortcuts.getAllShortcuts();

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          final action = shortcuts[index];
          final shortcut = KeyboardShortcuts.getShortcut(action);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  action.replaceAll('_', ' '),
                  style: TextStyle(
                    color: _settings.primaryColor,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _settings.primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    shortcut ?? 'N/A',
                    style: TextStyle(
                      color: _settings.primaryColor,
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _settings.primaryColor,
          foregroundColor: _settings.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: () {
          widget.themeService.resetToDefault();
          _updateSettings(TerminalThemes.darkTheme);
        },
        child: Text(
          'Reset to Default',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            color: _settings.backgroundColor,
          ),
        ),
      ),
    );
  }
}
