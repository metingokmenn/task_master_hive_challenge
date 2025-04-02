import 'package:flutter/material.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter category name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              final category = TaskCategory(
                id: DateTime.now().toString(),
                name: _controller.text,
              );
              Navigator.pop(context, category);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
