/// Represents the result of executing a command
class CommandResult {
  final String output;
  final int exitCode;
  final bool isError;
  final DateTime timestamp;

  CommandResult({
    required this.output,
    required this.exitCode,
    required this.isError,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => output;
}
