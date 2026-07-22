import 'package:flutter/material.dart';
import '../services/terminal_service.dart';

/// Widget for terminal input area
class TerminalInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TerminalService terminalService;
  final Function(String) onSubmitted;

  const TerminalInput({
    required this.controller,
    required this.focusNode,
    required this.terminalService,
    required this.onSubmitted,
    super.key,
  });

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.grey[900],
      child: Row(
        children: [
          const Text(
            '\$ ',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'Type a command...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'monospace',
                ),
              ),
              onSubmitted: (input) {
                widget.terminalService.resetHistoryIndex();
                widget.onSubmitted(input);
              },
            ),
          ),
        ],
      ),
    );
  }
}
