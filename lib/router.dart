import 'package:go_router/go_router.dart';
import 'package:to_do/view/create_task_view.dart';
import 'package:to_do/view/task_list_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TaskListView(),
    ),
    GoRoute(
      path: '/new-task',
      builder: (context, state) => CreateTaskView(),
    ),
  ],
);
