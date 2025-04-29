import 'package:flutter/material.dart';
import 'subject.dart';

class ManageSubjectsScreen extends StatefulWidget {
  final List<Subject> subjects;
  final Function(Subject) onEditSubject;
  final Function(Subject) onDeleteSubject;

  const ManageSubjectsScreen({
    super.key,
    required this.subjects,
    required this.onEditSubject,
    required this.onDeleteSubject,
  });

  @override
  ManageSubjectsScreenState createState() => ManageSubjectsScreenState();
}

class ManageSubjectsScreenState extends State<ManageSubjectsScreen> {
  void _handleEditSubject(Subject subject) async {
    await widget.onEditSubject(subject);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGE.Subjects'),
      ),
      body: widget.subjects.isEmpty
          ? const Center(child: Text('No subjects added yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.subjects.length,
              itemBuilder: (context, index) {
                final subject = widget.subjects[index];
                return Card(
                  child: ListTile(
                    title: Text(subject.name),
                    subtitle: Text(
                      'Attendance: ${subject.presentClasses}/${subject.totalClasses} (${subject.attendancePercentage.toStringAsFixed(1)}%)',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _handleEditSubject(subject),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            widget.onDeleteSubject(subject);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}