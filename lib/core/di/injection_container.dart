import 'package:get_it/get_it.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_all_todos.dart';
import '../../domain/usecases/toggle_todo_completion.dart';
import '../../domain/usecases/update_todo.dart';
import '../../presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodoCompletion(sl()));

  // BLoC
  sl.registerFactory(
    () => TodoBloc(
      getAllTodos: sl(),
      createTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
      toggleTodoCompletion: sl(),
    ),
  );
}
