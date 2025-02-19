import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do/model/enum/priority_enum.dart';
import 'package:to_do/model/task_model.dart';
import 'package:to_do/presenter/task_presenter.dart';

@GenerateNiceMocks([MockSpec<Database>()])
import 'task_presenter_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late TaskPresenter taskPresenter;
  late MockDatabase mockDatabase;

  setUp(() {
    taskPresenter = TaskPresenter();
    mockDatabase = MockDatabase();
    taskPresenter.setDatabase(mockDatabase);
  });

  group('TaskPresenter', () {
    test('insertTask should insert a task into the database', () async {
      final task = TaskModel(
        id: 1,
        description: 'Task 1',
        completed: false,
        priority: PriorityEnum.low,
      );

      await taskPresenter.insertTask(task);

      verify(mockDatabase.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).called(1);
    });

    test('getTasks should fetch all tasks from the database', () async {
      final tasks = [
        TaskModel(
          id: 1,
          description: 'Task 1',
          completed: false,
          priority: PriorityEnum.low,
        ),
        TaskModel(
          id: 2,
          description: 'Task 2',
          completed: true,
          priority: PriorityEnum.medium,
        ),
      ];

      when(mockDatabase.query('tasks'))
          .thenAnswer((_) async => List.generate(tasks.length, (i) {
                return tasks[i].toJson();
              }));

      final result = await taskPresenter.getTasks();

      expect(result, tasks);
      verify(mockDatabase.query('tasks')).called(1);
    });

    test('updateTask should update a task in the database', () async {
      final task = TaskModel(
        id: 1,
        description: 'Task 1',
        completed: false,
        priority: PriorityEnum.low,
      );

      await taskPresenter.updateTask(task);

      verify(mockDatabase.update(
        'tasks',
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      )).called(1);
    });

    test('deleteTask should delete a task from the database', () async {
      final taskId = 1;

      await taskPresenter.deleteTask(taskId);

      verify(mockDatabase.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [taskId],
      )).called(1);
    });
  });
}
