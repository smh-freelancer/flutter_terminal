import 'dart:io'
    show
        Directory,
        FileSystemEntity,
        FileSystemEntityType,
        FileSystemException,
        Platform,
        ProcessException;
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import '../models/command_result.dart';

/// Service for executing and managing terminal commands
class CommandService {
  final ProcessManager _processManager;
  String _currentDirectory = Platform.isWindows
      ? 'C:\\'
      : Platform.environment['HOME'] ?? '/home/user';

  CommandService({ProcessManager? processManager})
    : _processManager = processManager ?? const LocalProcessManager();

  /// Get current working directory
  String get currentDirectory => _currentDirectory;

  /// Execute a command and return the result
  Future<CommandResult> executeCommand(String input) async {
    try {
      final parts = input.trim().split(' ');
      final cmd = parts[0].toLowerCase();
      final args = parts.sublist(1);

      // Handle built-in commands
      final builtInResult = _handleBuiltInCommand(cmd, args);
      if (builtInResult != null) {
        return builtInResult;
      }

      // Execute system command
      return await _executeSystemCommand(cmd, args);
    } catch (e) {
      return CommandResult(
        output: 'Error: ${e.toString()}',
        exitCode: 1,
        isError: true,
      );
    }
  }

  /// Handle built-in commands
  CommandResult? _handleBuiltInCommand(String cmd, List<String> args) {
    switch (cmd) {
      case 'clear':
        return CommandResult(output: '', exitCode: 0, isError: false);

      case 'pwd':
        return CommandResult(
          output: _currentDirectory,
          exitCode: 0,
          isError: false,
        );

      case 'ls':
        return _listDirectory(args);

      case 'cd':
        if (args.isEmpty) {
          _currentDirectory = Platform.isWindows
              ? 'C:\\'
              : Platform.environment['HOME'] ?? '/';
        } else {
          _currentDirectory = args[0];
        }
        return CommandResult(output: '', exitCode: 0, isError: false);

      case 'echo':
        return CommandResult(
          output: args.join(' '),
          exitCode: 0,
          isError: false,
        );

      case 'date':
        return CommandResult(
          output: DateTime.now().toString(),
          exitCode: 0,
          isError: false,
        );

      case 'whoami':
        return CommandResult(
          output:
              Platform.environment['USER'] ??
              Platform.environment['USERNAME'] ??
              'user',
          exitCode: 0,
          isError: false,
        );

      case 'help':
        return CommandResult(
          output: _getHelpText(),
          exitCode: 0,
          isError: false,
        );

      case 'about':
        return CommandResult(
          output:
              'Flutter Terminal v2.0\nA professional terminal emulator built with Flutter\nSupports Windows, macOS, Linux, iOS, and Android',
          exitCode: 0,
          isError: false,
        );

      case 'platform':
        return CommandResult(
          output: Platform.operatingSystem,
          exitCode: 0,
          isError: false,
        );

      case 'exit':
      case 'quit':
        return CommandResult(output: 'Goodbye!', exitCode: 0, isError: false);

      default:
        return null;
    }
  }

  /// List a directory without relying on a host shell.
  CommandResult _listDirectory(List<String> args) {
    var includeHidden = false;
    String? requestedPath;

    for (final arg in args) {
      if (arg == '-a' || arg == '--all') {
        includeHidden = true;
      } else if (arg.startsWith('-')) {
        return CommandResult(
          output: 'ls: unsupported option: $arg',
          exitCode: 2,
          isError: true,
        );
      } else if (requestedPath == null) {
        requestedPath = arg;
      } else {
        return CommandResult(
          output: 'ls: multiple paths are not supported',
          exitCode: 2,
          isError: true,
        );
      }
    }

    final directoryPath = _resolvePath(requestedPath ?? _currentDirectory);
    final directory = Directory(directoryPath);
    try {
      if (!directory.existsSync()) {
        return CommandResult(
          output:
              'ls: cannot access \'${requestedPath ?? _currentDirectory}\': No such directory',
          exitCode: 2,
          isError: true,
        );
      }

      final entries = directory.listSync()
        ..sort(
          (a, b) => path.basename(a.path).compareTo(path.basename(b.path)),
        );
      final names = entries
          .map(_formatDirectoryEntry)
          .where((name) => includeHidden || !name.startsWith('.'))
          .toList();

      return CommandResult(
        output: names.join('\n'),
        exitCode: 0,
        isError: false,
      );
    } on FileSystemException catch (e) {
      return CommandResult(
        output: 'ls: ${e.message}',
        exitCode: 1,
        isError: true,
      );
    }
  }

  String _resolvePath(String input) {
    final expandedPath = input == '~'
        ? Platform.environment['HOME'] ?? _currentDirectory
        : input.startsWith('~/')
        ? path.join(
            Platform.environment['HOME'] ?? _currentDirectory,
            input.substring(2),
          )
        : input;

    return path.normalize(
      path.isAbsolute(expandedPath)
          ? expandedPath
          : path.join(_currentDirectory, expandedPath),
    );
  }

  String _formatDirectoryEntry(FileSystemEntity entry) {
    final name = path.basename(entry.path);
    return FileSystemEntity.typeSync(entry.path, followLinks: false) ==
            FileSystemEntityType.directory
        ? '$name/'
        : name;
  }

  /// Execute system command
  Future<CommandResult> _executeSystemCommand(
    String cmd,
    List<String> args,
  ) async {
    try {
      final result = await _processManager.run(
        [cmd, ...args],
        workingDirectory: _currentDirectory,
        runInShell: true,
      );

      final output = (result.stdout as String).trimRight();
      final isError = result.exitCode != 0;

      // Provide more context if command failed
      if (isError) {
        final errorOutput = (result.stderr as String).trimRight();
        final fullOutput = output.isNotEmpty && errorOutput.isNotEmpty
            ? '$output\n$errorOutput'
            : output.isNotEmpty
            ? output
            : errorOutput;

        return CommandResult(
          output: fullOutput.isEmpty
              ? 'Command exited with code ${result.exitCode}'
              : fullOutput,
          exitCode: result.exitCode,
          isError: true,
        );
      }

      return CommandResult(
        output: output,
        exitCode: result.exitCode,
        isError: false,
      );
    } on ProcessException catch (e) {
      return CommandResult(
        output: _formatCommandNotFoundError(cmd, e),
        exitCode: 127,
        isError: true,
      );
    }
  }

  /// Format command not found error with suggestions
  String _formatCommandNotFoundError(String cmd, ProcessException e) {
    final suggestions = _getSimilarCommands(cmd);
    final base = 'Command not found: $cmd';

    if (suggestions.isNotEmpty) {
      return '$base\n\nDid you mean:\n  ${suggestions.join('\n  ')}';
    }

    return base;
  }

  /// Get similar commands for suggestions
  List<String> _getSimilarCommands(String cmd) {
    final builtInCommands = [
      'clear',
      'pwd',
      'ls',
      'cd',
      'echo',
      'date',
      'whoami',
      'help',
      'about',
      'platform',
      'exit',
      'quit',
    ];

    final similar = <String>[];
    final lowerCmd = cmd.toLowerCase();

    for (final cmd in builtInCommands) {
      if (_similarity(cmd, lowerCmd) > 0.6) {
        similar.add(cmd);
      }
    }

    return similar.take(3).toList();
  }

  /// Calculate string similarity
  double _similarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    int matches = 0;
    for (int i = 0; i < a.length && i < b.length; i++) {
      if (a[i] == b[i]) matches++;
    }

    return matches / (a.length > b.length ? a.length : b.length);
  }

  /// Get help text with available commands
  String _getHelpText() {
    return '''
Available Commands:
  clear          Clear the terminal screen
  pwd            Print working directory
  ls [-a] [path] List directory contents
  cd [path]      Change directory
  echo [text]    Echo text to terminal
  date           Display current date and time
  whoami         Display current user
  platform       Display operating system
  help           Show this help message
  about          Show about information
  exit, quit     Exit the terminal

System commands are also supported where the platform provides them.
    '''
        .trim();
  }
}
