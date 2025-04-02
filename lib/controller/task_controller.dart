import 'package:get/get.dart';
import 'package:task_master_hive_challenge/model/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/task_category.dart';
import '../service/task_service.dart';
import '../service/category_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService(Get.find());
  final CategoryService _categoryService = CategoryService(Get.find());

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  List<TaskCategory> categories = <TaskCategory>[].obs;

  List<Task> tasks = <Task>[].obs;

  Rxn<TaskCategory> selectedCategory = Rxn<TaskCategory>();

  RxList<Task> searchResult = <Task>[].obs;

  RxString searchQuery = ''.obs;

  List<Task> get displayedTasks {
    if (searchQuery.value.isEmpty) {
      return tasks;
    } else {
      return searchResult;
    }
  }

  Future<void> editTask(String taskId, String newTodo) async {
    try {
      isLoading(true);
      errorMessage('');

      await _taskService.editTask(taskId, newTodo);

      fetchTasks();
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> search(String searchKey) async {
    searchQuery.value = searchKey;

    try {
      isLoading(true);
      errorMessage('');

      final results = await _taskService.searchTasks(searchKey);

      if (searchKey.isEmpty) {
        tasks.assignAll(results);
        searchResult.clear();
      } else {
        searchResult.assignAll(results);
      }
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchCategories();
    await fetchTasks();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      errorMessage('');

      categories.assignAll(await _categoryService.getCategories());
    } catch (e) {
      errorMessage(e.toString());

      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);

      errorMessage('');

      tasks.assignAll(await _taskService.getTasks());
    } catch (e) {
      errorMessage(e.toString());

      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(String category) async {
    try {
      isLoading(true);
      errorMessage('');

      final TaskCategory newCategory =
          TaskCategory(id: const Uuid().v4(), name: category);

      await _categoryService.createCategory(newCategory);

      categories.add(newCategory);
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(TaskCategory category) async {
    try {
      isLoading(true);
      errorMessage('');

      await _categoryService.removeCategory(category);

      categories.remove(category);
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      isLoading(true);
      errorMessage('');

      await _taskService.removeTask(task);

      tasks.remove(task);
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(String todo, TaskCategory category) async {
    try {
      isLoading(true);
      errorMessage('');

      final newTask =
          Task(id: const Uuid().v4(), todo: todo, category: category);

      await _taskService.createTask(newTask);
      tasks.add(newTask);
    } catch (e) {
      errorMessage(e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  bool checkIfTodoExists(String todo) {
    return tasks.any((task) => task.todo.toLowerCase() == todo.toLowerCase());
  }
}
