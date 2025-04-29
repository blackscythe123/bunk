import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'attendance_tracker.dart';
import 'subject.dart'; // Assuming Subject class is in subject.dart

class AttendanceDrawer extends StatelessWidget {
  final List<Subject> subjects;
  final double minimumAttendance;
  final Function(double) onMinimumAttendanceChanged;
  final VoidCallback onOverallAttendance;
  final VoidCallback onManageSubjects;
  final VoidCallback onTasks;

  const AttendanceDrawer({
    super.key,
    required this.subjects,
    required this.minimumAttendance,
    required this.onMinimumAttendanceChanged,
    required this.onOverallAttendance,
    required this.onManageSubjects,
    required this.onTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(135, 206, 235, 0.5)
                  : const Color.fromRGBO(135, 206, 235, 1.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Bunk',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Overall Attendance'),
            onTap: onOverallAttendance,
          ),
          ListTile(
            leading: const Icon(Icons.subject),
            title: const Text('All Subjects'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllSubjectsScreen(
                    subjects: subjects,
                    minimumAttendance: minimumAttendance,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Subjects'),
            onTap: onManageSubjects,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Required Attendance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MinimumAttendanceScreen(
                    minimumAttendance: minimumAttendance,
                    onMinimumAttendanceChanged: onMinimumAttendanceChanged,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tasks'),
            onTap: onTasks,
          ),
        ],
      ),
    );
  }
}

class OverallAttendanceScreen extends StatelessWidget {
  final List<Subject> subjects;
  final double minimumAttendance;

  const OverallAttendanceScreen({
    super.key,
    required this.subjects,
    required this.minimumAttendance,
  });

  @override
  Widget build(BuildContext context) {
    int totalClasses = 0;
    int totalPresent = 0;

    for (var subject in subjects) {
      totalClasses += subject.totalClasses;
      totalPresent += subject.presentClasses;
    }

    final tracker = AttendanceTracker(
      totalClasses: totalClasses,
      presentClasses: totalPresent,
      minimumAttendance: minimumAttendance,
    );

    double overallAttendance = tracker.attendancePercentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overall Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [
                              Colors.blue[300]!,
                              Colors.blue[500]!,
                            ],
                            [
                              Colors.blue[500]!,
                              Colors.blue[700]!,
                            ],
                          ],
                          durations: [15000, 9440],
                          heightPercentages: [
                            (100 - overallAttendance) / 100,
                            (100 - overallAttendance + 5) / 100,
                          ],
                          gradientBegin: Alignment.bottomCenter,
                          gradientEnd: Alignment.topCenter,
                        ),
                        waveAmplitude: 10,
                        size: const Size(double.infinity, double.infinity),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Text(
                    '${overallAttendance.round()}%',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              totalClasses == 0
                  ? 'Not a student, become one!'
                  : tracker.attendanceMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Present',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalPresent',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Absent',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${totalClasses - totalPresent}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Total classes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalClasses',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AllSubjectsScreen extends StatelessWidget {
  final List<Subject> subjects;
  final double minimumAttendance;

  const AllSubjectsScreen({
    super.key,
    required this.subjects,
    required this.minimumAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Subjects'),
      ),
      body: subjects.isEmpty
          ? const Center(child: Text('No subjects added yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(135, 206, 235, 0.8)
                      : const Color.fromRGBO(135, 206, 235, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Attendance: ${subject.presentClasses}/${subject.totalClasses}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: subject.attendancePercentage >= minimumAttendance
                                          ? Colors.green[700]!
                                          : Colors.red[700]!,
                                      value: subject.attendancePercentage,
                                      radius: 8,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.grey[300]!,
                                      value: 100 - subject.attendancePercentage,
                                      radius: 8,
                                      showTitle: false,
                                    ),
                                  ],
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 15,
                                ),
                              ),
                              Text(
                                '${subject.attendancePercentage.round()}%',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
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

class MinimumAttendanceScreen extends StatefulWidget {
  final double minimumAttendance;
  final Function(double) onMinimumAttendanceChanged;

  const MinimumAttendanceScreen({
    super.key,
    required this.minimumAttendance,
    required this.onMinimumAttendanceChanged,
  });

  @override
  MinimumAttendanceScreenState createState() => MinimumAttendanceScreenState();
}

class MinimumAttendanceScreenState extends State<MinimumAttendanceScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.minimumAttendance.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Required Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minimum Attendance (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(_controller.text);
                if (value != null && value >= 0 && value <= 100) {
                  widget.onMinimumAttendanceChanged(value);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid percentage between 0 and 100'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}