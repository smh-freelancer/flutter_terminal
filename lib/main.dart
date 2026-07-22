import 'package:flutter/material.dart';
import 'services/command_service.dart';
import 'services/terminal_service.dart';
import 'services/theme_service.dart';
import 'widgets/terminal_display.dart';
import 'widgets/enhanced_terminal_input.dart';
import 'widgets/settings_panel.dart';

void main() {
  runApp(const TerminalApp());
}

class TerminalApp extends StatelessWidget {
  const TerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Terminal',
          theme: _themeService.themeData,
          home: const TerminalView(),
        );
      },
    );
  }
}

// Global theme service instance
final _themeService = ThemeService();

class TerminalView extends StatefulWidget {
  const TerminalView({super.key});

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  late final TerminalService _terminalService;
  late final CommandService _commandService;
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _terminalService = TerminalService();
    _commandService = CommandService();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _processCommand(String input) async {
    if (input.trim().isEmpty) {
      setState(() {
        _terminalService.addOutput('');
      });
      _scrollToBottom();
      return;
    }

    // Handle clear command
    if (input.trim().toLowerCase() == 'clear') {
      setState(() {
        _terminalService.clear();
      });
      _controller.clear();
      _scrollToBottom();
      return;
    }

    // Execute command
    final result = await _commandService.executeCommand(input);

    setState(() {
      _terminalService.addCommandResult(input, result);
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
  Widget build(BuildContext context) {
    final settings = _themeService.currentSettings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Terminal v2.0'),
        backgroundColor: _themeService.currentSettings.isDarkMode
            ? Colors.grey[900]
            : Colors.grey[200],
        actions: [
          IconButton(
            tooltip: 'Settings (Ctrl + ,)',
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
          IconButton(
            tooltip: 'Toggle Theme',
            icon: const Icon(Icons.brightness_4),
            onPressed: () => _themeService.toggleDarkMode(),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Working directory indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            color: settings.isDarkMode ? Colors.grey[850] : Colors.grey[300],
            child: Text(
              'Directory: ${_commandService.currentDirectory}',
              style: TextStyle(
                color: settings.isDarkMode
                    ? Colors.grey[400]
                    : Colors.grey[700],
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: TerminalDisplay(
              history: _terminalService.history,
              scrollController: _scrollController,
              settings: settings,
            ),
          ),
          EnhancedTerminalInput(
            controller: _controller,
            focusNode: _focusNode,
            terminalService: _terminalService,
            onSubmitted: _processCommand,
            settings: settings,
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SettingsPanel(
        themeService: _themeService,
        onClose: () {
          Navigator.of(context).pop();
          setState(() {});
        },
      ),
    );
  }
}
