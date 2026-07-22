# Flutter Terminal

A polished, cross-platform terminal-style interface built with Flutter. Flutter Terminal provides an interactive command prompt, command history, autocomplete, configurable themes, and a focused set of built-in commands.

## Highlights

- Terminal-inspired interface with a persistent command history
- Built-in commands for navigation, system information, and common terminal actions
- Cross-platform `ls` support, including hidden files with `ls -a`
- Command autocomplete with inline descriptions
- Configurable font size and line height
- Dark, light, cyberpunk, and vintage themes
- Keyboard-friendly command input
- Flutter platform configurations for Android, iOS, Linux, macOS, Windows, and the web

## Built-in commands

| Command | Description |
| --- | --- |
| `clear` | Clear the terminal screen |
| `pwd` | Print the current working directory |
| `cd [path]` | Change directory |
| `ls [-a] [path]` | List directory contents; `-a` includes hidden files |
| `echo [text]` | Print text |
| `date` | Display the current date and time |
| `whoami` | Display the current user |
| `platform` | Display the operating system |
| `help` | Show the available commands |
| `about` | Show application information |
| `exit`, `quit` | Exit the terminal session |

Where the host platform provides a shell, other commands may also be executed. Their availability and behavior depend on the platform and its permissions.

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible with the Dart SDK specified in `pubspec.yaml`
- A configured device, emulator, simulator, or desktop target

### Run locally

```bash
flutter pub get
flutter run
```

To run on a specific platform, first list the available devices:

```bash
flutter devices
flutter run -d <device-id>
```

## Development

Format, test, and analyze the project before submitting changes:

```bash
dart format .
flutter test
flutter analyze
```

## Project structure

```text
lib/
├── main.dart                 # Application entry point and terminal screen
├── models/                   # Command, output, and settings models
├── services/                 # Command execution, terminal state, and theming
└── widgets/                  # Terminal display, input, and settings UI
test/                         # Automated tests
```

## Contributing

Contributions are welcome. Please keep changes focused, add or update tests when behavior changes, and run the development checks above before opening a pull request.

## License

Flutter Terminal is released under the [MIT License](LICENSE).
