/// Formats terminal output for better display
class OutputFormatter {
  /// Categorize output line type
  static OutputLineType categorizeLineType(String line) {
    if (line.isEmpty) {
      return OutputLineType.empty;
    }

    if (line.startsWith('\$ ')) {
      return OutputLineType.command;
    }

    if (line.contains('Error:') ||
        line.contains('error') ||
        line.contains('failed') ||
        line.contains('not found') ||
        line.contains('No such file')) {
      return OutputLineType.error;
    }

    if (line.contains('Warning:') ||
        line.contains('warning') ||
        line.contains('deprecated')) {
      return OutputLineType.warning;
    }

    if (line.startsWith('[') || line.startsWith('{') || line.startsWith('|')) {
      return OutputLineType.data;
    }

    if (line.contains('=>') || line.contains('->')) {
      return OutputLineType.info;
    }

    return OutputLineType.normal;
  }

  /// Format output line with proper indentation
  static String formatLine(String line) {
    // Preserve leading spaces
    final leadingSpaces = line.length - line.trimLeft().length;
    final trimmed = line.trim();

    if (trimmed.isEmpty) {
      return '';
    }

    return ' ' * leadingSpaces + trimmed;
  }

  /// Split output into lines and preserve formatting
  static List<String> parseOutput(String output) {
    if (output.isEmpty) {
      return [];
    }

    return output.split('\n');
  }

  /// Check if line is a table header
  static bool isTableHeader(String line) {
    final trimmed = line.trim();
    return trimmed.contains('|') &&
        (trimmed.contains('-') || trimmed.contains('═'));
  }

  /// Get color intensity based on content
  static double getColorIntensity(String line) {
    if (line.contains('success') || line.contains('✓')) {
      return 1.0; // Full brightness for success
    }

    if (line.contains('Error') || line.contains('failed')) {
      return 0.8; // Slightly muted for errors
    }

    return 0.9; // Default brightness
  }
}

enum OutputLineType {
  empty, // Empty line
  command, // Command line starting with $
  error, // Error message
  warning, // Warning message
  info, // Info message
  data, // Data/structured output
  normal, // Normal output
}
