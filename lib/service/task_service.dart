import 'package:task_master_hive_challenge/model/task.dart';
import 'package:task_master_hive_challenge/repository/i_task_repository.dart';

class TaskService {
  final ITaskRepository _taskRepository;

  TaskService(this._taskRepository);

  Future<List<Task>> getTasks() async {
    return await _taskRepository.getAllTasks();
  }

  Future<void> editTask(String id, String newTodo) async {
    await _taskRepository.editTask(id, newTodo);
  }

  Future<List<Task>> searchTasks(String searchQuery) async {
    return await _taskRepository.searchTasks(searchQuery);
  }

  Future<void> createTask(Task task) async {
    await _taskRepository.createTask(task);
  }

  Future<void> removeTask(Task task) async {
    await _taskRepository.removeTask(task);
  }
}
