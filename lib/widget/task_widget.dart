import 'package:flutter/material.dart';
import 'package:to_do/model/enum/priority_enum.dart';
import 'package:to_do/model/task_model.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel task;
  final Function(int) onRemove;
  final Function(int) onToggleCompletion;

  const TaskWidget({
    super.key,
    required this.task,
    required this.onRemove,
    required this.onToggleCompletion,
  });

  // Retorna a cor com base na prioridade
  Color _getPriorityColor(PriorityEnum priority) {
    switch (priority) {
      case PriorityEnum.low:
        return Colors.green;
      case PriorityEnum.medium:
        return Colors.orange;
      case PriorityEnum.high:
        return Colors.red;
      case PriorityEnum.critical:
        return Colors.purple;
    }
  }

  // Retorna o texto da prioridade em português
  String _getPriorityText(PriorityEnum priority) {
    switch (priority) {
      case PriorityEnum.low:
        return 'Baixa';
      case PriorityEnum.medium:
        return 'Média';
      case PriorityEnum.high:
        return 'Alta';
      case PriorityEnum.critical:
        return 'Crítica';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Checkbox(
              value: task.completed,
              onChanged: (value) {
                onToggleCompletion(task.id);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    style: TextStyle(
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      label: Text(
                        _getPriorityText(task.priority),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getPriorityColor(task.priority),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onRemove(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
