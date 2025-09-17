import 'package:flutter_test/flutter_test.dart';
import 'package:playground_bloc/domain/entities/todo.dart';
import 'package:playground_bloc/presentation/bloc/todo_event.dart';

void main() {
  group('TodoEvent', () {
    group('LoadTodos', () {
      test('should be a TodoEvent', () {
        expect(LoadTodos(), isA<TodoEvent>());
      });

      test('should have empty props', () {
        expect(LoadTodos().props, []);
      });

      test('should support equality', () {
        expect(LoadTodos(), equals(LoadTodos()));
      });
    });

    group('CreateTodo', () {
      const testTitle = 'Test Todo';
      const testDescription = 'Test Description';

      test('should be a TodoEvent', () {
        expect(const CreateTodo(title: testTitle, description: testDescription), isA<TodoEvent>());
      });

      test('should have correct props', () {
        const event = CreateTodo(title: testTitle, description: testDescription);
        expect(event.props, [testTitle, testDescription]);
      });

      test('should support equality', () {
        const event1 = CreateTodo(title: testTitle, description: testDescription);
        const event2 = CreateTodo(title: testTitle, description: testDescription);
        const event3 = CreateTodo(title: 'Different', description: testDescription);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('UpdateTodo', () {
      final testTodo = Todo(
        id: 1,
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      test('should be a TodoEvent', () {
        expect(UpdateTodo(testTodo), isA<TodoEvent>());
      });

      test('should have correct props', () {
        final event = UpdateTodo(testTodo);
        expect(event.props, [testTodo]);
      });

      test('should support equality', () {
        final event1 = UpdateTodo(testTodo);
        final event2 = UpdateTodo(testTodo);
        final differentTodo = testTodo.copyWith(title: 'Different');
        final event3 = UpdateTodo(differentTodo);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('DeleteTodo', () {
      const testId = 1;

      test('should be a TodoEvent', () {
        expect(const DeleteTodo(testId), isA<TodoEvent>());
      });

      test('should have correct props', () {
        const event = DeleteTodo(testId);
        expect(event.props, [testId]);
      });

      test('should support equality', () {
        const event1 = DeleteTodo(testId);
        const event2 = DeleteTodo(testId);
        const event3 = DeleteTodo(2);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('ToggleTodoCompletion', () {
      final testTodo = Todo(
        id: 1,
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      test('should be a TodoEvent', () {
        expect(ToggleTodoCompletion(testTodo), isA<TodoEvent>());
      });

      test('should have correct props', () {
        final event = ToggleTodoCompletion(testTodo);
        expect(event.props, [testTodo]);
      });

      test('should support equality', () {
        final event1 = ToggleTodoCompletion(testTodo);
        final event2 = ToggleTodoCompletion(testTodo);
        final differentTodo = testTodo.copyWith(title: 'Different');
        final event3 = ToggleTodoCompletion(differentTodo);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });
  });
}
