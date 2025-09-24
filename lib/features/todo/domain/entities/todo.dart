import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt, updatedAt];
}
