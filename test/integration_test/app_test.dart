import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:playground_bloc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo App Integration Tests', () {
    testWidgets('should complete full todo workflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state - should show empty state
      expect(find.text('No todos yet'), findsOneWidget);
      expect(find.text('Tap the + button to add your first todo'), findsOneWidget);

      // Tap the floating action button to add a new todo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify add todo dialog is shown
      expect(find.text('Add New Todo'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Fill in the todo form
      await tester.enterText(find.byType(TextFormField).first, 'Integration Test Todo');
      await tester.enterText(
        find.byType(TextFormField).last,
        'This is a test todo for integration testing',
      );

      // Submit the form
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Verify the todo was added and dialog is closed
      expect(find.text('Add New Todo'), findsNothing);
      expect(find.text('Integration Test Todo'), findsOneWidget);
      expect(find.text('This is a test todo for integration testing'), findsOneWidget);

      // Verify success message is shown
      expect(find.text('Todo created successfully'), findsOneWidget);

      // Test todo completion toggle
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Verify todo is marked as completed
      expect(find.text('Todo status updated successfully'), findsOneWidget);

      // Test todo editing
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify edit dialog is shown
      expect(find.text('Edit Todo'), findsOneWidget);

      // Update the todo
      await tester.enterText(find.byType(TextFormField).first, 'Updated Integration Test Todo');
      await tester.enterText(
        find.byType(TextFormField).last,
        'Updated description for integration testing',
      );

      // Submit the update
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // Verify the todo was updated
      expect(find.text('Edit Todo'), findsNothing);
      expect(find.text('Updated Integration Test Todo'), findsOneWidget);
      expect(find.text('Updated description for integration testing'), findsOneWidget);
      expect(find.text('Todo updated successfully'), findsOneWidget);

      // Test todo deletion
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify delete confirmation dialog
      expect(find.text('Delete Todo'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this todo?'), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify todo was deleted and empty state is shown
      expect(find.text('Delete Todo'), findsNothing);
      expect(find.text('Updated Integration Test Todo'), findsNothing);
      expect(find.text('No todos yet'), findsOneWidget);
      expect(find.text('Todo deleted successfully'), findsOneWidget);
    });

    testWidgets('should handle form validation', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Verify validation errors are shown
      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);

      // Fill only title
      await tester.enterText(find.byType(TextFormField).first, 'Test Title');
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Verify description validation error
      expect(find.text('Please enter a description'), findsOneWidget);

      // Fill description
      await tester.enterText(find.byType(TextFormField).last, 'Test Description');
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Verify form is submitted successfully
      expect(find.text('Add New Todo'), findsNothing);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should handle multiple todos', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Add first todo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'First Todo');
      await tester.enterText(find.byType(TextFormField).last, 'First Description');
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Add second todo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Second Todo');
      await tester.enterText(find.byType(TextFormField).last, 'Second Description');
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Add third todo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Third Todo');
      await tester.enterText(find.byType(TextFormField).last, 'Third Description');
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Verify all todos are displayed
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);
      expect(find.text('Third Todo'), findsOneWidget);

      // Complete the first todo
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Verify completion
      expect(find.text('Todo status updated successfully'), findsOneWidget);

      // Delete the second todo
      await tester.tap(find.byType(PopupMenuButton<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify deletion
      expect(find.text('Second Todo'), findsNothing);
      expect(find.text('Todo deleted successfully'), findsOneWidget);

      // Verify remaining todos
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Third Todo'), findsOneWidget);
    });
  });
}
