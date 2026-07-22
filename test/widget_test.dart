import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_terminal/services/command_service.dart';

void main() {
  group('ls', () {
    late Directory directory;
    late CommandService service;

    setUp(() {
      directory = Directory.systemTemp.createTempSync('flutter_terminal_ls_');
      Directory(
        '${directory.path}${Platform.pathSeparator}folder',
      ).createSync();
      File('${directory.path}${Platform.pathSeparator}alpha.txt').createSync();
      File('${directory.path}${Platform.pathSeparator}.hidden').createSync();
      service = CommandService();
    });

    tearDown(() => directory.deleteSync(recursive: true));

    test(
      'lists a supplied directory in name order and marks directories',
      () async {
        final result = await service.executeCommand('ls ${directory.path}');

        expect(result.isError, isFalse);
        expect(result.output, 'alpha.txt\nfolder/');
      },
    );

    test('includes hidden files with -a', () async {
      final result = await service.executeCommand('ls -a ${directory.path}');

      expect(result.isError, isFalse);
      expect(result.output, '.hidden\nalpha.txt\nfolder/');
    });

    test('reports a missing directory', () async {
      final result = await service.executeCommand(
        'ls ${directory.path}/missing',
      );

      expect(result.exitCode, 2);
      expect(result.isError, isTrue);
      expect(result.output, contains('No such directory'));
    });
  });
}
