import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';
import 'package:task_master_hive_challenge/repository/i_category_repository.dart';

class HiveCategoryRepository implements ICategoryRepository {
  static const String _categoriesBoxName = 'categories';

  Future<Box<TaskCategory>> _getCategoriesBox() async {
    return await Hive.openBox<TaskCategory>(_categoriesBoxName);
  }

  @override
  Future<List<TaskCategory>> getAllCategories() async {
    final box = await _getCategoriesBox();
    return box.values.toList();
  }

  @override
  Future<void> createCategory(TaskCategory category) async {
    final box = await _getCategoriesBox();
    bool categoryExists = box.values.any((boxCategory) =>
        boxCategory.name.toLowerCase() == category.name.toLowerCase());

    if (!categoryExists) {
      await box.add(category);
    }
  }

  @override
  Future<void> removeCategory(TaskCategory category) async {
    final box = await _getCategoriesBox();
    await box.delete(category.key);
  }
}
