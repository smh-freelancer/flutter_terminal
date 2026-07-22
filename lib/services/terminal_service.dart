import '../models/command_result.dart';

/// Service for managing terminal state and history
class TerminalService {
  final List<String> _history = [
    'Welcome to Flutter Terminal v2.0',
    'Type "help" for available commands.\n',
  ];

  final List<String> _commandHistory = [];
  int _commandHistoryIndex = -1;

  List<String> get history => _history;
  List<String> get commandHistory => _commandHistory;

  /// Add output to terminal history
  void addOutput(String text) {
    _history.add(text);
  }

  /// Add command and its result to history
  void addCommandResult(String command, CommandResult result) {
    _history.add('\$ $command');
    if (result.output.isNotEmpty) {
      _history.add(result.output);
    }
    _history.add('');

    // Add to command history
    if (command.isNotEmpty) {
      _commandHistory.add(command);
      _commandHistoryIndex = -1;
    }
  }

  /// Clear terminal history
  void clear() {
    _history.clear();
  }

  /// Get previous command from history
  String? getPreviousCommand() {
    if (_commandHistory.isEmpty) return null;

    if (_commandHistoryIndex < _commandHistory.length - 1) {
      _commandHistoryIndex++;
      return _commandHistory[_commandHistory.length - 1 - _commandHistoryIndex];
    }
    return null;
  }

  /// Get next command from history
  String? getNextCommand() {
    if (_commandHistoryIndex > 0) {
      _commandHistoryIndex--;
      return _commandHistory[_commandHistory.length - 1 - _commandHistoryIndex];
    } else if (_commandHistoryIndex == 0) {
      _commandHistoryIndex--;
      return '';
    }
    return null;
  }

  /// Reset command history index
  void resetHistoryIndex() {
    _commandHistoryIndex = -1;
  }
}
