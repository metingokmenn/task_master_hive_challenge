import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master_hive_challenge/model/task.dart';
import 'package:task_master_hive_challenge/repository/i_task_repository.dart';

class HiveTaskRepository implements ITaskRepository {
  static const String _tasksBoxName = 'tasks';

  Future<Box<Task>> _getTasksBox() async {
    return await Hive.openBox<Task>(_tasksBoxName);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final box = await _getTasksBox();
    return box.values.toList();
  }

  @override
  Future<void> editTask(String id, String newTodo) async {
    final box = await _getTasksBox();
    final task = box.values.firstWhere((task) => task.id == id);
    task.todo = newTodo;
    await task.save();
  }

  @override
  Future<List<Task>> searchTasks(String searchQuery) async {
    final box = await _getTasksBox();
    if (searchQuery.isEmpty) {
      return box.values.toList();
    }

    final searchLower = searchQuery.toLowerCase();
    final tasksByText = box.values
        .where((task) => task.todo.toLowerCase().contains(searchLower))
        .toList();

    final tasksByCategory = box.values
        .where((task) => task.category.name.toLowerCase().contains(searchLower))
        .toList();

    final Set<Task> resultSet = {...tasksByText, ...tasksByCategory};
    return resultSet.toList();
  }

  @override
  Future<void> createTask(Task task) async {
    final box = await _getTasksBox();
    bool taskExists = box.values.any(
        (boxTask) => boxTask.todo.toLowerCase() == task.todo.toLowerCase());

    if (!taskExists) {
      await box.add(task);
    }
  }

  @override
  Future<void> removeTask(Task task) async {
    final box = await _getTasksBox();
    await box.delete(task.key);
  }
}
