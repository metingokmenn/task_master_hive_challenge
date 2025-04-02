import 'package:flutter/material.dart';
import 'package:task_master_hive_challenge/model/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.todo),
      subtitle: Text(task.category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final TextEditingController controller =
                  TextEditingController(text: task.todo);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Task'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter new task text',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        onEdit(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
