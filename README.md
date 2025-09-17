# Todo List App - Clean Architecture with BLoC

A Flutter todo list application built using Clean Architecture principles with MVVM/BLoC pattern and SQLite for local data storage.

## Architecture Overview

This project follows Clean Architecture with three main layers:

### 1. Domain Layer (Business Logic)

- **Entities**: Core business objects (`Todo`)
- **Use Cases**: Application-specific business rules
  - `GetAllTodos`: Retrieve all todos
  - `CreateTodo`: Create a new todo
  - `UpdateTodo`: Update an existing todo
  - `DeleteTodo`: Delete a todo
  - `ToggleTodoCompletion`: Toggle todo completion status
- **Repository Interface**: Abstract data access contract

### 2. Data Layer (Data Management)

- **Data Models**: Data transfer objects (`TodoModel`)
- **Repository Implementation**: Concrete implementation of repository interface
- **Data Sources**: SQLite database helper
- **External Dependencies**: Database, APIs, etc.

### 3. Presentation Layer (UI & State Management)

- **BLoC**: State management using flutter_bloc
- **Screens**: UI screens (`TodoListScreen`)
- **Widgets**: Reusable UI components
- **Events & States**: BLoC events and states

## Project Structure

```
lib/
├── core/
│   └── di/
│       └── injection_container.dart    # Dependency injection setup
├── data/
│   ├── datasources/
│   │   └── database_helper.dart        # SQLite database helper
│   ├── models/
│   │   └── todo_model.dart             # Data model for Todo
│   └── repositories/
│       └── todo_repository_impl.dart   # Repository implementation
├── domain/
│   ├── entities/
│   │   └── todo.dart                   # Todo entity
│   ├── repositories/
│   │   └── todo_repository.dart        # Repository interface
│   └── usecases/
│       ├── create_todo.dart
│       ├── delete_todo.dart
│       ├── get_all_todos.dart
│       ├── toggle_todo_completion.dart
│       └── update_todo.dart
├── presentation/
│   ├── bloc/
│   │   ├── todo_bloc.dart              # Main BLoC
│   │   ├── todo_event.dart             # BLoC events
│   │   └── todo_state.dart             # BLoC states
│   ├── screens/
│   │   └── todo_list_screen.dart       # Main screen
│   └── widgets/
│       ├── add_todo_dialog.dart        # Add todo dialog
│       └── todo_item.dart              # Todo item widget
└── main.dart                           # App entry point
```

## Features

- ✅ **Create Todo**: Add new todos with title and description
- ✅ **Read Todos**: View all todos in a list
- ✅ **Update Todo**: Edit existing todos
- ✅ **Delete Todo**: Remove todos with confirmation
- ✅ **Toggle Completion**: Mark todos as complete/incomplete
- ✅ **Local Storage**: SQLite database for data persistence
- ✅ **Clean Architecture**: Separation of concerns
- ✅ **State Management**: BLoC pattern for reactive UI
- ✅ **Dependency Injection**: GetIt for loose coupling
- ✅ **Error Handling**: Comprehensive error handling with Either pattern
- ✅ **Modern UI**: Material Design 3 with beautiful animations

## Dependencies

- `flutter_bloc`: State management
- `sqflite`: Local SQLite database
- `get_it`: Dependency injection
- `dartz`: Functional programming (Either type)
- `equatable`: Value equality
- `path`: Path manipulation for database

## Getting Started

1. **Install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

### Adding a Todo

1. Tap the floating action button (+)
2. Enter title and description
3. Tap "Add Todo"

### Managing Todos

- **Complete/Incomplete**: Tap the checkbox next to any todo
- **Edit**: Tap the menu (⋮) and select "Edit"
- **Delete**: Tap the menu (⋮) and select "Delete"

## Architecture Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add new features
4. **Flexibility**: Easy to swap implementations
5. **Clean Code**: Follows SOLID principles

## Database Schema

```sql
CREATE TABLE todos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
)
```

## State Management Flow

1. **UI Event** → BLoC Event
2. **BLoC Event** → Use Case
3. **Use Case** → Repository
4. **Repository** → Data Source
5. **Data Source** → Database
6. **Response** flows back through the layers
7. **BLoC State** → UI Update

## Error Handling

The app uses the Either pattern from the `dartz` package for functional error handling:

- `Left`: Error case
- `Right`: Success case

This ensures type-safe error handling throughout the application.

## Future Enhancements

- [ ] Categories/Tags for todos
- [ ] Due dates and reminders
- [ ] Search and filter functionality
- [ ] Dark theme support
- [ ] Data synchronization
- [ ] Offline-first architecture
- [ ] Unit and integration tests
