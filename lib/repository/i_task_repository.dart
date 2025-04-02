import 'package:task_master_hive_challenge/model/task.dart';

abstract class ITaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> editTask(String id, String newTodo);
  Future<List<Task>> searchTasks(String searchQuery);
  Future<void> createTask(Task task);
  Future<void> removeTask(Task task);
}
