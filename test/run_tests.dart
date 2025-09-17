import 'dart:io';

/// Test runner script for running different types of tests
void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart test/run_tests.dart [unit|widget|integration|all]');
    exit(1);
  }

  final testType = args[0].toLowerCase();

  switch (testType) {
    case 'unit':
      runUnitTests();
      break;
    case 'widget':
      runWidgetTests();
      break;
    case 'integration':
      runIntegrationTests();
      break;
    case 'all':
      runAllTests();
      break;
    default:
      print('Invalid test type. Use: unit, widget, integration, or all');
      exit(1);
  }
}

void runUnitTests() {
  print('Running unit tests...');
  final result = Process.runSync('flutter', [
    'test',
    'test/domain/',
    'test/data/',
  ], runInShell: true);

  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print('Errors: ${result.stderr}');
  }

  exit(result.exitCode);
}

void runWidgetTests() {
  print('Running widget tests...');
  final result = Process.runSync('flutter', ['test', 'test/presentation/'], runInShell: true);

  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print('Errors: ${result.stderr}');
  }

  exit(result.exitCode);
}

void runIntegrationTests() {
  print('Running integration tests...');
  final result = Process.runSync('flutter', ['test', 'integration_test/'], runInShell: true);

  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print('Errors: ${result.stderr}');
  }

  exit(result.exitCode);
}

void runAllTests() {
  print('Running all tests...');
  final result = Process.runSync('flutter', ['test'], runInShell: true);

  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print('Errors: ${result.stderr}');
  }

  exit(result.exitCode);
}
