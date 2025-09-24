import 'package:get_it/get_it.dart';
import '../../features/todo/data/datasources/database_helper.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/create_todo.dart';
import '../../features/todo/domain/usecases/delete_todo.dart';
import '../../features/todo/domain/usecases/get_all_todos.dart';
import '../../features/todo/domain/usecases/toggle_todo_completion.dart';
import '../../features/todo/domain/usecases/update_todo.dart';
import '../../features/todo/presentation/bloc/todo_bloc.dart';

// Reimbursement imports
import '../../features/reimbursement/data/datasources/reimbursement_database_helper.dart';
import '../../features/reimbursement/data/repositories/reimbursement_repository_impl.dart';
import '../../features/reimbursement/domain/repositories/reimbursement_repository.dart';
import '../../features/reimbursement/domain/usecases/create_reimbursement.dart';
import '../../features/reimbursement/domain/usecases/get_all_reimbursements.dart';
import '../../features/reimbursement/domain/usecases/update_reimbursement.dart';
import '../../features/reimbursement/domain/usecases/submit_reimbursement.dart';
import '../../features/reimbursement/domain/usecases/add_attachment_to_reimbursement.dart';
import '../../features/reimbursement/domain/usecases/delete_reimbursement.dart';
import '../../features/reimbursement/presentation/bloc/reimbursement_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  sl.registerLazySingleton<ReimbursementDatabaseHelper>(
    () => ReimbursementDatabaseHelper(),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));
  sl.registerLazySingleton<ReimbursementRepository>(
    () => ReimbursementRepositoryImpl(sl()),
  );

  // Use cases - Todo
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodoCompletion(sl()));

  // Use cases - Reimbursement
  sl.registerLazySingleton(() => GetAllReimbursements(sl()));
  sl.registerLazySingleton(() => CreateReimbursement(sl()));
  sl.registerLazySingleton(() => UpdateReimbursement(sl()));
  sl.registerLazySingleton(() => SubmitReimbursement(sl()));
  sl.registerLazySingleton(() => AddAttachmentToReimbursement(sl()));
  sl.registerLazySingleton(() => DeleteReimbursement(sl()));

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

  sl.registerFactory(
    () => ReimbursementBloc(
      getAllReimbursements: sl(),
      createReimbursement: sl(),
      updateReimbursement: sl(),
      submitReimbursement: sl(),
      addAttachmentToReimbursement: sl(),
      deleteReimbursement: sl(),
    ),
  );
}
