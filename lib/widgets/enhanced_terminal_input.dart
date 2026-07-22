import 'package:flutter/material.dart';
import '../models/command_registry.dart';
import '../models/terminal_settings.dart';
import '../services/terminal_service.dart';

/// Enhanced terminal input widget with autocomplete
class EnhancedTerminalInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TerminalService terminalService;
  final Function(String) onSubmitted;
  final TerminalSettings settings;

  const EnhancedTerminalInput({
    required this.controller,
    required this.focusNode,
    required this.terminalService,
    required this.onSubmitted,
    required this.settings,
    super.key,
  });

  @override
  State<EnhancedTerminalInput> createState() => _EnhancedTerminalInputState();
}

class _EnhancedTerminalInputState extends State<EnhancedTerminalInput> {
  List<String> _suggestions = [];
  int _selectedSuggestionIndex = -1;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateSuggestions);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSuggestions);
    super.dispose();
  }

  void _updateSuggestions() {
    final text = widget.controller.text;
    final parts = text.split(' ');

    if (parts.isNotEmpty) {
      final partial = parts.last;
      setState(() {
        _suggestions = CommandRegistry.getAutocompleteSuggestions(partial);
        _selectedSuggestionIndex = -1;
        _showSuggestions = _suggestions.isNotEmpty && partial.isNotEmpty;
      });
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _applySuggestion(String suggestion) {
    final text = widget.controller.text;
    final parts = text.split(' ');

    if (parts.isNotEmpty) {
      parts[parts.length - 1] = suggestion;
      final newText = '${parts.join(' ')} ';
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    }

    setState(() {
      _showSuggestions = false;
      _suggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Autocomplete suggestions dropdown
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: settings.isDarkMode ? Colors.grey[800] : Colors.grey[300],
              border: Border(top: BorderSide(color: settings.primaryColor)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                final isSelected = index == _selectedSuggestionIndex;
                final description = CommandRegistry.getCommandDescription(
                  suggestion,
                );

                return Material(
                  color: isSelected
                      ? (settings.isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey[400])
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => _applySuggestion(suggestion),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion,
                            style: TextStyle(
                              color: settings.primaryColor,
                              fontFamily: 'monospace',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (description != null)
                            Text(
                              description,
                              style: TextStyle(
                                color: settings.isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        // Input area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[200],
          child: Row(
            children: [
              Text(
                '\$ ',
                style: TextStyle(
                  color: settings.primaryColor,
                  fontFamily: 'monospace',
                  fontSize: settings.fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: true,
                  style: TextStyle(
                    color: settings.isDarkMode ? Colors.white : Colors.black,
                    fontFamily: 'monospace',
                    fontSize: settings.fontSize,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Type a command (type to autocomplete)...',
                    hintStyle: TextStyle(
                      color: settings.isDarkMode
                          ? Colors.grey
                          : Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                  onSubmitted: (input) {
                    widget.terminalService.resetHistoryIndex();
                    widget.onSubmitted(input);
                    setState(() {
                      _showSuggestions = false;
                      _suggestions = [];
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
