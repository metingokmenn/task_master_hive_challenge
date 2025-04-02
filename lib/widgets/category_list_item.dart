import 'package:flutter/material.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';

class CategoryListItem extends StatelessWidget {
  final TaskCategory category;
  final VoidCallback onDelete;

  const CategoryListItem({
    Key? key,
    required this.category,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
