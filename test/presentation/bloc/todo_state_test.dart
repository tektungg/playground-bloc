import 'package:flutter_test/flutter_test.dart';
import 'package:playground_bloc/domain/entities/todo.dart';
import 'package:playground_bloc/presentation/bloc/todo_state.dart';

void main() {
  group('TodoState', () {
    group('TodoInitial', () {
      test('should be a TodoState', () {
        expect(TodoInitial(), isA<TodoState>());
      });

      test('should have empty props', () {
        expect(TodoInitial().props, []);
      });

      test('should support equality', () {
        expect(TodoInitial(), equals(TodoInitial()));
      });
    });

    group('TodoLoading', () {
      test('should be a TodoState', () {
        expect(TodoLoading(), isA<TodoState>());
      });

      test('should have empty props', () {
        expect(TodoLoading().props, []);
      });

      test('should support equality', () {
        expect(TodoLoading(), equals(TodoLoading()));
      });
    });

    group('TodoLoaded', () {
      final testTodos = [
        Todo(
          id: 1,
          title: 'Test Todo 1',
          description: 'Test Description 1',
          isCompleted: false,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        Todo(
          id: 2,
          title: 'Test Todo 2',
          description: 'Test Description 2',
          isCompleted: true,
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
      ];

      test('should be a TodoState', () {
        expect(TodoLoaded(testTodos), isA<TodoState>());
      });

      test('should have correct props', () {
        final state = TodoLoaded(testTodos);
        expect(state.props, [testTodos]);
      });

      test('should support equality', () {
        final state1 = TodoLoaded(testTodos);
        final state2 = TodoLoaded(testTodos);
        final differentTodos = [testTodos[0]];
        final state3 = TodoLoaded(differentTodos);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('should handle empty todos list', () {
        final state = TodoLoaded([]);
        expect(state.todos, []);
        expect(state.props, [[]]);
      });
    });

    group('TodoError', () {
      const testMessage = 'Test Error Message';

      test('should be a TodoState', () {
        expect(const TodoError(testMessage), isA<TodoState>());
      });

      test('should have correct props', () {
        const state = TodoError(testMessage);
        expect(state.props, [testMessage]);
      });

      test('should support equality', () {
        const state1 = TodoError(testMessage);
        const state2 = TodoError(testMessage);
        const state3 = TodoError('Different Message');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('should store error message', () {
        const state = TodoError(testMessage);
        expect(state.message, testMessage);
      });
    });

    group('TodoSuccess', () {
      const testMessage = 'Test Success Message';

      test('should be a TodoState', () {
        expect(const TodoSuccess(testMessage), isA<TodoState>());
      });

      test('should have correct props', () {
        const state = TodoSuccess(testMessage);
        expect(state.props, [testMessage]);
      });

      test('should support equality', () {
        const state1 = TodoSuccess(testMessage);
        const state2 = TodoSuccess(testMessage);
        const state3 = TodoSuccess('Different Message');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('should store success message', () {
        const state = TodoSuccess(testMessage);
        expect(state.message, testMessage);
      });
    });
  });
}
