import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(2)
  final String id;

  @HiveField(3)
  String todo;

  @HiveField(4)
  TaskCategory category;

  Task({required this.id, required this.todo, required this.category});
}
