# Testing Guide

This directory contains comprehensive test files for the Todo App built with Flutter and BLoC pattern.

## Test Structure

```
test/
├── domain/                    # Domain layer tests
│   ├── entities/             # Entity tests
│   └── usecases/             # Use case tests
├── data/                     # Data layer tests
│   ├── models/               # Model tests
│   └── repositories/         # Repository tests
├── presentation/             # Presentation layer tests
│   ├── bloc/                 # BLoC tests
│   ├── screens/              # Screen tests
│   └── widgets/              # Widget tests
├── helpers/                  # Test helper utilities
├── integration_test/         # Integration tests
├── test_config.dart          # Test configuration
├── run_tests.dart           # Test runner script
└── README.md                # This file
```

## Test Types

### 1. Unit Tests

- **Location**: `test/domain/`, `test/data/`
- **Purpose**: Test individual functions, methods, and classes in isolation
- **Examples**: Entity tests, use case tests, repository tests

### 2. Widget Tests

- **Location**: `test/presentation/`
- **Purpose**: Test individual widgets and their interactions
- **Examples**: BLoC tests, screen tests, widget tests

### 3. Integration Tests

- **Location**: `test/integration_test/`
- **Purpose**: Test the complete app workflow end-to-end
- **Examples**: Full user journey tests

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test Types

```bash
# Unit tests only
dart test/run_tests.dart unit

# Widget tests only
dart test/run_tests.dart widget

# Integration tests only
dart test/run_tests.dart integration

# All tests
dart test/run_tests.dart all
```

### Run Specific Test Files

```bash
# Run a specific test file
flutter test test/domain/entities/todo_test.dart

# Run tests in a specific directory
flutter test test/domain/

# Run tests with coverage
flutter test --coverage
```

## Test Coverage

To generate test coverage reports:

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html
```

## Test Dependencies

The following testing dependencies are included in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mockito: ^5.4.4
  build_runner: ^2.4.9
  json_serializable: ^6.11.1
  test: ^1.25.8
  integration_test:
    sdk: flutter
```

## Test Helpers

### TestDataFactory

Provides factory methods for creating test data:

```dart
final todo = TestDataFactory.createTodo(
  title: 'Test Todo',
  description: 'Test Description',
);
```

### WidgetTestHelpers

Provides helper methods for widget testing:

```dart
final widget = WidgetTestHelpers.createTestApp(
  child: MyWidget(),
  todoBloc: mockTodoBloc,
);
```

### StateTestHelpers

Provides helper methods for creating test states:

```dart
final state = StateTestHelpers.createLoadedState(todos: testTodos);
```

## Mock Setup

### BLoC Mocks

```dart
class MockTodoBloc extends Mock implements TodoBloc {}

// Setup mock
when(mockTodoBloc.state).thenReturn(TodoInitial());
when(mockTodoBloc.add(any)).thenReturn(null);
```

### Repository Mocks

```dart
class MockTodoRepository extends Mock implements TodoRepository {}

// Setup mock
when(mockRepository.getAllTodos()).thenAnswer((_) async => Right(testTodos));
```

## Test Best Practices

### 1. Test Structure

- Use the AAA pattern: Arrange, Act, Assert
- Group related tests using `group()`
- Use descriptive test names

### 2. Mocking

- Mock external dependencies
- Verify interactions with mocks
- Use `verifyNoMoreInteractions()` when appropriate

### 3. Widget Testing

- Test widget behavior, not implementation details
- Use `pumpAndSettle()` for animations
- Test user interactions (taps, text input, etc.)

### 4. Integration Testing

- Test complete user workflows
- Use realistic test data
- Test error scenarios

### 5. Test Data

- Use consistent test data across tests
- Create reusable test data factories
- Avoid hardcoded values in tests

## Continuous Integration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v1
```

## Troubleshooting

### Common Issues

1. **Mock not working**: Ensure you're using `@GenerateMocks` annotation
2. **Widget not found**: Use `pumpAndSettle()` after async operations
3. **Test timeout**: Increase timeout duration in test configuration
4. **Coverage not generated**: Ensure tests are run with `--coverage` flag

### Debug Tips

1. Use `debugDumpApp()` to inspect widget tree
2. Use `tester.printToConsole()` for debugging
3. Use `pump()` instead of `pumpAndSettle()` for step-by-step debugging
4. Check test output for detailed error messages

## Contributing

When adding new tests:

1. Follow the existing test structure
2. Use appropriate test helpers
3. Add tests for both success and failure scenarios
4. Update this README if adding new test categories
5. Ensure all tests pass before submitting PR

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing Guide](https://flutter.dev/docs/testing/integration-tests)
