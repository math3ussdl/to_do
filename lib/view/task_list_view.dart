import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/model/task_model.dart';
import 'package:to_do/presenter/task_presenter.dart';
import 'package:to_do/widget/loading_widget.dart';
import 'package:to_do/widget/task_widget.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskPresenter _taskPresenter = TaskPresenter();

  List<TaskModel> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskList = await _taskPresenter.getTasks();

    setState(() {
      tasks = taskList;
      loading = false;
    });
  }

  Future<void> _deleteTask(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _taskPresenter.deleteTask(id);
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          loading
              ? null
              : AppBar(
                title: Text('Lista de Tarefas (${tasks.length})'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.go('/new-task');
                    },
                  ),
                ],
              ),
      body:
          loading
              ? LoadingWidget()
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskWidget(
                    task: task,
                    onRemove: _deleteTask,
                    onToggleCompletion: (i) {
                      _taskPresenter.updateTask(
                        task.copyWith(completed: !task.completed),
                      );
                      _loadTasks();
                    },
                  );
                },
              ),
    );
  }
}
