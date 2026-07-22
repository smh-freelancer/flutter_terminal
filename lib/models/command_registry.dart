/// Registry of all available commands with descriptions
class CommandRegistry {
  static const Map<String, String> builtInCommands = {
    'clear': 'Clear the terminal screen',
    'pwd': 'Print working directory',
    'cd': 'Change directory',
    'echo': 'Echo text to terminal',
    'date': 'Display current date and time',
    'whoami': 'Display current user',
    'platform': 'Display operating system',
    'help': 'Show help message',
    'about': 'Show about information',
    'exit': 'Exit the terminal',
    'quit': 'Exit the terminal',
    'ls': 'List directory contents',
    'dir': 'List directory contents (Windows)',
    'cat': 'Display file contents',
    'mkdir': 'Create directory',
    'touch': 'Create empty file',
    'rm': 'Remove file',
    'rmdir': 'Remove directory',
    'copy': 'Copy files',
    'move': 'Move files',
    'find': 'Find files',
    'grep': 'Search text',
  };

  /// Get all available commands (built-in + system)
  static List<String> getAllCommands() {
    return builtInCommands.keys.toList();
  }

  /// Get autocomplete suggestions for a partial command
  static List<String> getAutocompleteSuggestions(String partial) {
    if (partial.isEmpty) return [];

    final lowerPartial = partial.toLowerCase();
    return builtInCommands.keys
        .where((cmd) => cmd.startsWith(lowerPartial))
        .toList();
  }

  /// Get description for a command
  static String? getCommandDescription(String cmd) {
    return builtInCommands[cmd.toLowerCase()];
  }
}
