import 'package:task_master_hive_challenge/model/task_category.dart';
import 'package:task_master_hive_challenge/repository/i_category_repository.dart';

class CategoryService {
  final ICategoryRepository _categoryRepository;

  CategoryService(this._categoryRepository);

  Future<List<TaskCategory>> getCategories() async {
    return await _categoryRepository.getAllCategories();
  }

  Future<void> createCategory(TaskCategory category) async {
    await _categoryRepository.createCategory(category);
  }

  Future<void> removeCategory(TaskCategory category) async {
    await _categoryRepository.removeCategory(category);
  }
}
