import 'package:flutter_test/flutter_test.dart';

/// Test configuration and setup
class TestConfig {
  /// Default test timeout
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Widget test timeout
  static const Duration widgetTestTimeout = Duration(seconds: 10);

  /// Integration test timeout
  static const Duration integrationTestTimeout = Duration(minutes: 2);

  /// Test data directory
  static const String testDataDir = 'test/test_data';

  /// Mock data directory
  static const String mockDataDir = 'test/mock_data';

  /// Test database name
  static const String testDatabaseName = 'test_todos.db';

  /// Setup test environment
  static void setupTestEnvironment() {
    // Configure test environment
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up any global test configurations
    // This can be called in main() of test files
  }

  /// Clean up test environment
  static void cleanupTestEnvironment() {
    // Clean up any test resources
    // This can be called in tearDown() of test files
  }
}

/// Test categories
class TestCategories {
  static const String unit = 'unit';
  static const String widget = 'widget';
  static const String integration = 'integration';
  static const String performance = 'performance';
}

/// Test tags
class TestTags {
  static const String smoke = 'smoke';
  static const String regression = 'regression';
  static const String critical = 'critical';
  static const String slow = 'slow';
  static const String fast = 'fast';
}
