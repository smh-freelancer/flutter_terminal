import 'package:flutter/material.dart';
import '../models/output_formatter.dart';
import '../models/terminal_settings.dart';

/// Widget that displays the terminal output history
class TerminalDisplay extends StatelessWidget {
  final List<String> history;
  final ScrollController scrollController;
  final TerminalSettings settings;

  const TerminalDisplay({
    required this.history,
    required this.scrollController,
    required this.settings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tap to bring focus to input
      },
      child: Container(
        color: settings.backgroundColor,
        child: history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to Flutter Terminal v2.0',
                      style: TextStyle(
                        color: settings.primaryColor,
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Type "help" for available commands',
                      style: TextStyle(
                        color: settings.isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[600],
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final line = history[index];
                  return _buildLineWidget(line);
                },
              ),
      ),
    );
  }

  Widget _buildLineWidget(String line) {
    final lineType = OutputFormatter.categorizeLineType(line);
    final formattedLine = OutputFormatter.formatLine(line);
    final intensity = OutputFormatter.getColorIntensity(line);

    Color textColor;
    FontWeight fontWeight;
    double fontSize = settings.fontSize;

    switch (lineType) {
      case OutputLineType.command:
        textColor = Colors.cyanAccent;
        fontWeight = FontWeight.bold;
        break;
      case OutputLineType.error:
        textColor = settings.errorColor;
        fontWeight = FontWeight.w500;
        break;
      case OutputLineType.warning:
        textColor = Colors.yellow[600]!;
        fontWeight = FontWeight.w500;
        break;
      case OutputLineType.info:
        textColor = Colors.lightBlue[300]!;
        fontWeight = FontWeight.normal;
        break;
      case OutputLineType.data:
        textColor = settings.successColor;
        fontWeight = FontWeight.w300;
        fontSize = settings.fontSize - 1;
        break;
      case OutputLineType.empty:
        textColor = Colors.transparent;
        fontWeight = FontWeight.normal;
        break;
      case OutputLineType.normal:
        textColor = settings.successColor;
        fontWeight = FontWeight.normal;
    }

    // Adjust color intensity
    final adjustedColor = Color.lerp(
      settings.backgroundColor,
      textColor,
      intensity,
    )!;

    return Text(
      formattedLine,
      style: TextStyle(
        color: adjustedColor,
        fontSize: fontSize,
        fontFamily: 'monospace',
        fontWeight: fontWeight,
        height: settings.lineHeight,
      ),
    );
  }
}
