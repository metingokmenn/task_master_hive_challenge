import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master_hive_challenge/model/task.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';
import 'package:task_master_hive_challenge/pages/home_page.dart';
import 'package:task_master_hive_challenge/repository/hive_category_repository.dart';
import 'package:task_master_hive_challenge/repository/hive_task_repository.dart';
import 'package:task_master_hive_challenge/service/category_service.dart';
import 'package:task_master_hive_challenge/service/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskCategoryAdapter());

  final taskRepository = HiveTaskRepository();
  final categoryRepository = HiveCategoryRepository();

  final taskService = TaskService(taskRepository);
  final categoryService = CategoryService(categoryRepository);

  runApp(MyApp(
    taskService: taskService,
    categoryService: categoryService,
  ));
}

class MyApp extends StatelessWidget {
  final TaskService taskService;
  final CategoryService categoryService;

  const MyApp({
    Key? key,
    required this.taskService,
    required this.categoryService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomePage(
        taskService: taskService,
        categoryService: categoryService,
      ),
    );
  }
}
