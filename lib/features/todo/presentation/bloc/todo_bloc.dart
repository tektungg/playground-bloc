import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_todo.dart' as create_todo;
import '../../domain/usecases/delete_todo.dart' as delete_todo;
import '../../domain/usecases/get_all_todos.dart';
import '../../domain/usecases/toggle_todo_completion.dart' as toggle_todo;
import '../../domain/usecases/update_todo.dart' as update_todo;
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  // Repository
  final GetAllTodos getAllTodos;

  // Use cases
  final create_todo.CreateTodo createTodo;
  final update_todo.UpdateTodo updateTodo;
  final delete_todo.DeleteTodo deleteTodo;
  final toggle_todo.ToggleTodoCompletion toggleTodoCompletion;

  // Constructor
  TodoBloc({
    required this.getAllTodos,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodoCompletion,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<CreateTodo>(_onCreateTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoCompletion>(_onToggleTodoCompletion);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await getAllTodos();
    result.fold((failure) => emit(TodoError(failure)), (todos) => emit(TodoLoaded(todos)));
  }

  Future<void> _onCreateTodo(CreateTodo event, Emitter<TodoState> emit) async {
    final result = await createTodo(title: event.title, description: event.description);

    result.fold((failure) => emit(TodoError(failure)), (todo) {
      emit(const TodoSuccess('Todo created successfully'));
      add(LoadTodos());
    });
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    final result = await updateTodo(event.todo);

    result.fold((failure) => emit(TodoError(failure)), (todo) {
      emit(const TodoSuccess('Todo updated successfully'));
      add(LoadTodos());
    });
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    final result = await deleteTodo(event.id);

    result.fold((failure) => emit(TodoError(failure)), (_) {
      emit(const TodoSuccess('Todo deleted successfully'));
      add(LoadTodos());
    });
  }

  Future<void> _onToggleTodoCompletion(ToggleTodoCompletion event, Emitter<TodoState> emit) async {
    final result = await toggleTodoCompletion(event.todo);

    result.fold((failure) => emit(TodoError(failure)), (todo) {
      emit(const TodoSuccess('Todo status updated successfully'));
      add(LoadTodos());
    });
  }
}
