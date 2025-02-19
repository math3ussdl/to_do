import 'package:to_do/model/enum/priority_enum.dart';

class TaskModel {
  final int id;
  final String description;
  final bool completed;
  final PriorityEnum priority;

  TaskModel({
    required this.id,
    required this.description,
    required this.completed,
    required this.priority,
  });

  TaskModel copyWith({
    int? id,
    String? description,
    bool? completed,
    PriorityEnum? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      description: json['description'],
      completed: json['completed'] == 1,
      priority: PriorityEnum.values[json['priority']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'completed': completed ? 1 : 0,
      'priority': priority.index,
    };
  }

  @override
  String toString() {
    return '''
      TaskModel{
        id: $id,
        description: $description,
        completed: $completed,
        priority: $priority
      }
    ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.description == description &&
        other.completed == completed &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        completed.hashCode ^
        priority.hashCode;
  }
}
