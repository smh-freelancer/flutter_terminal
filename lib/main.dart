import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const TerminalApp());
}

class TerminalApp extends StatelessWidget {
  const TerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Terminal',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'monospace',
      ),
      home: const TerminalView(),
    );
  }
}

class TerminalView extends StatefulWidget {
  const TerminalView({super.key});

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  final List<String> _history = [
    'Welcome to Flutter Terminal v1.0',
    'Type "help" for available commands.\n',
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  void _processCommand(String input) {
    setState(() async {
      _history.add('\$ $input');
      final parts = input.trim().split(' ');
      final cmd = parts[0];

      switch (cmd) {
        case '':
          break;
        case 'clear':
          _history.clear();
          break;
        case 'help':
          _history.add(
            'Available commands: help, clear, echo, date, whoami, about',
          );
          break;
        case 'echo':
          _history.add(parts.sublist(1).join(' '));
          break;
        case 'date':
          _history.add(DateTime.now().toString());
          break;
        case 'whoami':
          _history.add('flutter_user');
          break;
        case 'about':
          _history.add('A terminal emulator UI built with Flutter.');
          break;
        default:
          // Attempt to run the command on the host OS (Desktop only)
          try {
            final result = await Process.run(cmd, parts.sublist(1));
            if (result.stdout.toString().isNotEmpty) {
              _history.add(result.stdout.toString().trim());
            }
            if (result.stderr.toString().isNotEmpty) {
              _history.add('Error: ${result.stderr.toString().trim()}');
            }
          } catch (e) {
            _history.add(
              'Failed to execute command (Mobile OS sandbox restriction or invalid command).',
            );
          }
        // _history.add('Command not found: $cmd');
      }
      _history.add(''); // Add empty line for the next prompt
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    _focusNode.requestFocus(), // Tap to bring up keyboard/focus
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _history[index],
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14.0,
                        fontFamily: 'monospace',
                      ),
                    );
                  },
                ),
              ),
            ),
            // Input Area
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              color: Colors.grey[900],
              child: Row(
                children: [
                  const Text(
                    '\$ ',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      onSubmitted: _processCommand,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
