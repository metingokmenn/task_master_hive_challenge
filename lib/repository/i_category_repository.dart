import 'package:task_master_hive_challenge/model/task_category.dart';

abstract class ICategoryRepository {
  Future<List<TaskCategory>> getAllCategories();
  Future<void> createCategory(TaskCategory category);
  Future<void> removeCategory(TaskCategory category);
}
