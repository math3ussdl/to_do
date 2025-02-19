import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/model/enum/priority_enum.dart';
import 'package:to_do/model/task_model.dart';
import 'package:to_do/presenter/task_presenter.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final TaskPresenter _taskPresenter = TaskPresenter();

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  PriorityEnum _selectedPriority = PriorityEnum.low;
  bool loading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch,
        description: _descriptionController.text,
        completed: false,
        priority: _selectedPriority,
      );

      await _taskPresenter.insertTask(newTask);
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<PriorityEnum>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                ),
                items:
                    PriorityEnum.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
