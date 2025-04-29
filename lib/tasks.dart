import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;

  Task({
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });

  Task copyWith({String? title, DateTime? dueDate, bool? isCompleted}) {
    return Task(
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(int, bool) onTaskCompleted;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onTaskCompleted,
  });

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = widget.tasks;
  }

  @override
  void didUpdateWidget(TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks != oldWidget.tasks) {
      setState(() {
        _tasks = widget.tasks;
      });
    }
  }

  void _addTask() async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
    if (result != null) {
      widget.onAddTask(result);
      setState(() {
        _tasks = widget.tasks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks added yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onTaskCompleted(index, value);
                          setState(() {
                            _tasks = widget.tasks;
                          });
                        }
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    subtitle: task.dueDate != null
                        ? Text(
                            'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}',
                            style: TextStyle(
                              color: task.isCompleted ? Colors.grey : null,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  DateTime? _dueDate;

  Future<void> _selectDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color.fromRGBO(135, 206, 235, 0.5),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1C2526),
                    onSurface: Colors.white,
                  ),
                  dialogTheme: const DialogTheme(backgroundColor: Color(0xFF1C2526)),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color.fromRGBO(135, 206, 235, 1.0),
                    onPrimary: Colors.black,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                  dialogTheme: const DialogTheme(backgroundColor: Colors.white),
                ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && mounted) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'No due date'
                        : 'Due: ${DateFormat('MMM d, yyyy').format(_dueDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDueDate(context),
                  child: const Text('Pick Due Date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.pop(
                context,
                Task(
                  title: _titleController.text,
                  dueDate: _dueDate,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a task title'),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}