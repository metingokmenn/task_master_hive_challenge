import 'package:flutter/material.dart';
import 'package:task_master_hive_challenge/model/task.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';

class AddTaskDialog extends StatefulWidget {
  final List<TaskCategory> categories;

  const AddTaskDialog({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _controller;
  late TaskCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedCategory = widget.categories.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter task text',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskCategory>(
            value: _selectedCategory,
            items: widget.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              final task = Task(
                id: DateTime.now().toString(),
                todo: _controller.text,
                category: _selectedCategory,
              );
              Navigator.pop(context, task);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
