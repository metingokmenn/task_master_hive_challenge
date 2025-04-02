import 'package:hive_flutter/hive_flutter.dart';

part 'task_category.g.dart';

@HiveType(typeId: 1)
class TaskCategory extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  TaskCategory({
    required this.id,
    required this.name,
  });
}
