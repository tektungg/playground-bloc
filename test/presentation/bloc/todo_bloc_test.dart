import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:playground_bloc/domain/entities/todo.dart';
import 'package:playground_bloc/domain/usecases/create_todo.dart';
import 'package:playground_bloc/domain/usecases/delete_todo.dart';
import 'package:playground_bloc/domain/usecases/get_all_todos.dart';
import 'package:playground_bloc/domain/usecases/toggle_todo_completion.dart';
import 'package:playground_bloc/domain/usecases/update_todo.dart';
import 'package:playground_bloc/presentation/bloc/todo_bloc.dart';
import 'package:playground_bloc/presentation/bloc/todo_event.dart';
import 'package:playground_bloc/presentation/bloc/todo_state.dart';

class MockGetAllTodos extends Mock implements GetAllTodos {}

class MockCreateTodo extends Mock implements CreateTodo {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class MockToggleTodoCompletion extends Mock implements ToggleTodoCompletion {}

void main() {
  late TodoBloc todoBloc;
  late MockGetAllTodos mockGetAllTodos;
  late MockCreateTodo mockCreateTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;
  late MockToggleTodoCompletion mockToggleTodoCompletion;

  setUp(() {
    mockGetAllTodos = MockGetAllTodos();
    mockCreateTodo = MockCreateTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();
    mockToggleTodoCompletion = MockToggleTodoCompletion();

    todoBloc = TodoBloc(
      getAllTodos: mockGetAllTodos,
      createTodo: mockCreateTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
      toggleTodoCompletion: mockToggleTodoCompletion,
    );
  });

  tearDown(() {
    todoBloc.close();
  });

  group('TodoBloc', () {
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

    test('initial state should be TodoInitial', () {
      expect(todoBloc.state, TodoInitial());
    });

    group('LoadTodos', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when LoadTodos is added and succeeds',
        build: () {
          when(mockGetAllTodos()).thenAnswer((_) async => Right(testTodos));
          return todoBloc;
        },
        act: (bloc) => bloc.add(LoadTodos()),
        expect: () => [TodoLoading(), TodoLoaded(testTodos)],
        verify: (_) {
          verify(mockGetAllTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError] when LoadTodos is added and fails',
        build: () {
          when(mockGetAllTodos()).thenAnswer((_) async => const Left('Failed to load todos'));
          return todoBloc;
        },
        act: (bloc) => bloc.add(LoadTodos()),
        expect: () => [TodoLoading(), const TodoError('Failed to load todos')],
        verify: (_) {
          verify(mockGetAllTodos()).called(1);
        },
      );
    });

    group('CreateTodo', () {
      const testTitle = 'New Todo';
      const testDescription = 'New Description';

      blocTest<TodoBloc, TodoState>(
        'emits [TodoSuccess, TodoLoading, TodoLoaded] when CreateTodo succeeds',
        build: () {
          when(
            mockCreateTodo(title: testTitle, description: testDescription),
          ).thenAnswer((_) async => Right(testTodos[0]));
          when(mockGetAllTodos()).thenAnswer((_) async => Right(testTodos));
          return todoBloc;
        },
        act: (bloc) => bloc.add(const CreateTodo(title: testTitle, description: testDescription)),
        expect:
            () => [
              const TodoSuccess('Todo created successfully'),
              TodoLoading(),
              TodoLoaded(testTodos),
            ],
        verify: (_) {
          verify(mockCreateTodo(title: testTitle, description: testDescription)).called(1);
          verify(mockGetAllTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when CreateTodo fails',
        build: () {
          when(
            mockCreateTodo(title: testTitle, description: testDescription),
          ).thenAnswer((_) async => const Left('Failed to create todo'));
          return todoBloc;
        },
        act: (bloc) => bloc.add(const CreateTodo(title: testTitle, description: testDescription)),
        expect: () => [const TodoError('Failed to create todo')],
        verify: (_) {
          verify(mockCreateTodo(title: testTitle, description: testDescription)).called(1);
          verifyNever(mockGetAllTodos());
        },
      );
    });

    group('UpdateTodo', () {
      final testTodo = testTodos[0];

      blocTest<TodoBloc, TodoState>(
        'emits [TodoSuccess, TodoLoading, TodoLoaded] when UpdateTodo succeeds',
        build: () {
          when(mockUpdateTodo(testTodo)).thenAnswer((_) async => Right(testTodo));
          when(mockGetAllTodos()).thenAnswer((_) async => Right(testTodos));
          return todoBloc;
        },
        act: (bloc) => bloc.add(UpdateTodo(testTodo)),
        expect:
            () => [
              const TodoSuccess('Todo updated successfully'),
              TodoLoading(),
              TodoLoaded(testTodos),
            ],
        verify: (_) {
          verify(mockUpdateTodo(testTodo)).called(1);
          verify(mockGetAllTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when UpdateTodo fails',
        build: () {
          when(
            mockUpdateTodo(testTodo),
          ).thenAnswer((_) async => const Left('Failed to update todo'));
          return todoBloc;
        },
        act: (bloc) => bloc.add(UpdateTodo(testTodo)),
        expect: () => [const TodoError('Failed to update todo')],
        verify: (_) {
          verify(mockUpdateTodo(testTodo)).called(1);
          verifyNever(mockGetAllTodos());
        },
      );
    });

    group('DeleteTodo', () {
      const testId = 1;

      blocTest<TodoBloc, TodoState>(
        'emits [TodoSuccess, TodoLoading, TodoLoaded] when DeleteTodo succeeds',
        build: () {
          when(mockDeleteTodo(testId)).thenAnswer((_) async => const Right(null));
          when(mockGetAllTodos()).thenAnswer((_) async => Right(testTodos));
          return todoBloc;
        },
        act: (bloc) => bloc.add(const DeleteTodo(testId)),
        expect:
            () => [
              const TodoSuccess('Todo deleted successfully'),
              TodoLoading(),
              TodoLoaded(testTodos),
            ],
        verify: (_) {
          verify(mockDeleteTodo(testId)).called(1);
          verify(mockGetAllTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when DeleteTodo fails',
        build: () {
          when(mockDeleteTodo(testId)).thenAnswer((_) async => const Left('Failed to delete todo'));
          return todoBloc;
        },
        act: (bloc) => bloc.add(const DeleteTodo(testId)),
        expect: () => [const TodoError('Failed to delete todo')],
        verify: (_) {
          verify(mockDeleteTodo(testId)).called(1);
          verifyNever(mockGetAllTodos());
        },
      );
    });

    group('ToggleTodoCompletion', () {
      final testTodo = testTodos[0];

      blocTest<TodoBloc, TodoState>(
        'emits [TodoSuccess, TodoLoading, TodoLoaded] when ToggleTodoCompletion succeeds',
        build: () {
          when(mockToggleTodoCompletion(testTodo)).thenAnswer((_) async => Right(testTodo));
          when(mockGetAllTodos()).thenAnswer((_) async => Right(testTodos));
          return todoBloc;
        },
        act: (bloc) => bloc.add(ToggleTodoCompletion(testTodo)),
        expect:
            () => [
              const TodoSuccess('Todo status updated successfully'),
              TodoLoading(),
              TodoLoaded(testTodos),
            ],
        verify: (_) {
          verify(mockToggleTodoCompletion(testTodo)).called(1);
          verify(mockGetAllTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoError] when ToggleTodoCompletion fails',
        build: () {
          when(
            mockToggleTodoCompletion(testTodo),
          ).thenAnswer((_) async => const Left('Failed to toggle todo'));
          return todoBloc;
        },
        act: (bloc) => bloc.add(ToggleTodoCompletion(testTodo)),
        expect: () => [const TodoError('Failed to toggle todo')],
        verify: (_) {
          verify(mockToggleTodoCompletion(testTodo)).called(1);
          verifyNever(mockGetAllTodos());
        },
      );
    });
  });
}
