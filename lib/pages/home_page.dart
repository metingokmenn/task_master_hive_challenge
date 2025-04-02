import 'package:flutter/material.dart';
import 'package:task_master_hive_challenge/model/task.dart';
import 'package:task_master_hive_challenge/model/task_category.dart';
import 'package:task_master_hive_challenge/service/category_service.dart';
import 'package:task_master_hive_challenge/service/task_service.dart';

class HomePage extends StatefulWidget {
  final TaskService taskService;
  final CategoryService categoryService;

  const HomePage({
    Key? key,
    required this.taskService,
    required this.categoryService,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _tasks = [];
  List<TaskCategory> _categories = [];
  String _searchQuery = '';
  TaskCategory? _selectedCategory;
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _newTodoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _editTaskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    _newTodoController.dispose();
    _searchController.dispose();
    _editTaskController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final tasks = await widget.taskService.getTasks();
    final categories = await widget.categoryService.getCategories();
    setState(() {
      _tasks = tasks;
      _categories = categories;
    });
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category first')),
        );
        return;
      }

      final task = Task(
        id: DateTime.now().toString(),
        todo: _newTodoController.text,
        category: _selectedCategory!,
      );

      await widget.taskService.createTask(task);
      _newTodoController.clear();
      _selectedCategory = null;
      _loadData();
    }
  }

  Future<void> _addCategory() async {
    if (_newCategoryController.text.isNotEmpty) {
      final category = TaskCategory(
        id: DateTime.now().toString(),
        name: _newCategoryController.text,
      );

      await widget.categoryService.createCategory(category);
      _newCategoryController.clear();
      _loadData();
    }
  }

  Future<void> _editTask(Task task, String newTodo) async {
    await widget.taskService.editTask(task.id, newTodo);
    _editTaskController.clear();
    _loadData();
  }

  Future<void> _deleteTask(Task task) async {
    await widget.taskService.removeTask(task);
    _loadData();
  }

  Future<void> _deleteCategory(TaskCategory category) async {
    await widget.categoryService.removeCategory(category);
    _loadData();
  }

  Future<void> _searchTasks(String query) async {
    setState(() {
      _searchQuery = query;
    });
    final tasks = await widget.taskService.searchTasks(query);
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Task Master',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Task Master',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newTodoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a todo';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: _addTask,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.deepOrange,
                      ),
                    ),
                    hintText: 'Enter your task',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Select Category:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ..._categories.map(
                      (category) => GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Category'),
                              content: Text(
                                  'Are you sure you want to delete ${category.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _deleteCategory(category);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: _selectedCategory?.id == category.id,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                      ),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add),
                      label: const Text('New Category'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Add New Category'),
                            content: TextField(
                              controller: _newCategoryController,
                              decoration: const InputDecoration(
                                  hintText: 'Category Name'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _newCategoryController.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _addCategory();
                                  Navigator.pop(context);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _searchTasks,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchTasks('');
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      onDismissed: (direction) => _deleteTask(task),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: Text(task.todo),
                        subtitle: Text(task.category.name),
                        trailing: IconButton(
                          onPressed: () {
                            _editTaskController.text = task.todo;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Task'),
                                content: TextField(
                                  controller: _editTaskController,
                                  decoration: const InputDecoration(
                                      hintText: 'Task Name'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _editTaskController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _editTask(task, _editTaskController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Edit'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, size: 18),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
