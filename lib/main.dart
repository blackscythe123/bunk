import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'attendance_drawer.dart';
import 'subject.dart';
import 'timer_tab.dart';
import 'subject_card.dart';
import 'add_subject_dialog.dart';
import 'manage_subjects_screen.dart';
import 'time_tab.dart';
import 'tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool('isDarkTheme') ?? true;
  runApp(FigmaToCodeApp(initialDarkTheme: isDarkTheme));
}

class FigmaToCodeApp extends StatefulWidget {
  final bool initialDarkTheme;

  const FigmaToCodeApp({super.key, required this.initialDarkTheme});

  @override
  FigmaToCodeAppState createState() => FigmaToCodeAppState();
}

class FigmaToCodeAppState extends State<FigmaToCodeApp> {
  late bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.initialDarkTheme;
  }

  void toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) => value.setBool('isDarkTheme', _isDarkTheme));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bunk',
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[200],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(135, 206, 235, 1.0),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(135, 206, 235, 1.0),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedLabelStyle: TextStyle(color: Colors.black54),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(135, 206, 235, 1.0),
          foregroundColor: Colors.black,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black54),
          hintStyle: TextStyle(color: Colors.black54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        dividerColor: Colors.black54,
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey),
          ),
          textStyle: TextStyle(color: Colors.black),
        ),
        dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C2526),
        cardColor: const Color(0xFF3A3F44),
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(135, 206, 235, 0.5),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white70),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(135, 206, 235, 0.5),
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF3A3F44),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3F44),
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        dividerColor: Colors.white54,
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF3A3F44)),
          ),
          textStyle: TextStyle(color: Colors.white),
        ),
        dialogTheme: const DialogTheme(backgroundColor: Color(0xFF3A3F44)),
      ),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const AndroidCompact1(),
    );
  }
}

class AndroidCompact1 extends StatefulWidget {
  const AndroidCompact1({super.key});

  @override
  AndroidCompact1State createState() => AndroidCompact1State();
}

class AndroidCompact1State extends State<AndroidCompact1> {
  int _bottomNavIndex = 1;
  List<Subject> subjects = [];
  List<Task> tasks = [];
  String? _selectedSubjectName;
  double _minimumAttendance = 75.0;
  String? _tempSelectedDay; // Tracks temporarily selected day
  DateTime? _lastSelectionDate; // Tracks when _tempSelectedDay was set
  bool _hasClassesForSelectedDay = false; // Tracks if selected day has classes

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _loadTasks();
    _loadSelectedSubject();
    _loadMinimumAttendance();
  }

  Future<void> _loadMinimumAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _minimumAttendance = prefs.getDouble('minimumAttendance') ?? 75.0;
    });
  }

  Future<void> _saveMinimumAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('minimumAttendance', _minimumAttendance);
  }

  void _updateMinimumAttendance(double newValue) {
    setState(() {
      _minimumAttendance = newValue;
      _saveMinimumAttendance();
    });
  }

  Future<void> _loadSubjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subjectsJson = prefs.getString('subjects');
      if (subjectsJson != null) {
        final List<dynamic> subjectsList = jsonDecode(subjectsJson);
        List<Subject> loadedSubjects = subjectsList.map((json) => Subject.fromJson(json)).toList();
        for (var subject in loadedSubjects) {
          subject.schedules.forEach((day, scheduleList) {
            scheduleList.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
          });
        }
        setState(() {
          subjects = loadedSubjects;
        });
      }
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');
      if (tasksJson != null) {
        final List<dynamic> tasksList = jsonDecode(tasksJson);
        setState(() {
          tasks = tasksList.map((json) => Task.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await prefs.setString('tasks', tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _saveTasks();
    });
  }

  void _updateTaskCompletion(int index, bool isCompleted) {
    setState(() {
      tasks[index] = tasks[index].copyWith(isCompleted: isCompleted);
      _saveTasks();
    });
  }

  Future<void> _loadSelectedSubject() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedSubjectName = prefs.getString('selectedSubjectName');
    if (selectedSubjectName != null && mounted) {
      setState(() {
        _selectedSubjectName = selectedSubjectName;
      });
    }
  }

  Future<void> _saveSubjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subjectsJson = jsonEncode(subjects.map((subject) => subject.toJson()).toList());
      await prefs.setString('subjects', subjectsJson);
    } catch (e) {
      print('Error saving subjects: $e');
    }
  }

  Future<void> _saveSelectedSubject() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedSubjectName != null) {
      await prefs.setString('selectedSubjectName', _selectedSubjectName!);
    } else {
      await prefs.remove('selectedSubjectName');
    }
  }

  void _onStudySessionSaved() {
    setState(() {
      _saveSubjects();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _addSubject() async {
    if (!mounted) return;
    final result = await showDialog<Subject>(
      context: context,
      builder: (context) => AddSubjectDialog(subjects: subjects),
    );
    if (result != null && mounted) {
      setState(() {
        final existingSubjectIndex = subjects.indexWhere(
          (subject) => subject.name.trim().toLowerCase() == result.name.trim().toLowerCase(),
        );

        if (existingSubjectIndex != -1) {
          final existingSubject = subjects[existingSubjectIndex];
          final updatedSchedules = Map<String, List<DaySchedule>>.from(existingSubject.schedules);

          for (var entry in result.schedules.entries) {
            final day = entry.key;
            final newSchedule = entry.value[0];

            bool hasOverlap = false;
            for (var otherSubject in subjects) {
              if (otherSubject != existingSubject && otherSubject.schedules.containsKey(day)) {
                for (var existingSchedule in otherSubject.schedules[day]!) {
                  if (newSchedule.overlapsWith(existingSchedule)) {
                    hasOverlap = true;
                    break;
                  }
                }
              }
              if (hasOverlap) break;
            }

            if (!hasOverlap) {
              if (!updatedSchedules.containsKey(day)) {
                updatedSchedules[day] = [];
              }
              updatedSchedules[day]!.add(newSchedule);
              updatedSchedules[day]!.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Schedule for ${result.name} on $day overlaps with another subject. Skipping this schedule.',
                  ),
                ),
              );
            }
          }

          subjects[existingSubjectIndex] = existingSubject.copyWith(
            schedules: updatedSchedules,
          );
        } else {
          final sortedSchedules = Map<String, List<DaySchedule>>.from(result.schedules);
          sortedSchedules.forEach((day, scheduleList) {
            scheduleList.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
          });
          subjects.add(Subject(
            name: result.name,
            schedules: sortedSchedules,
            dailyAttendance: result.dailyAttendance,
          ));
        }
        _saveSubjects();
      });
    }
  }

  void _editSubject(Subject subject) async {
    final result = await showDialog<Subject>(
      context: context,
      builder: (context) => AddSubjectDialog(
        subjects: subjects,
        subjectToEdit: subject,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        final index = subjects.indexOf(subject);
        final sortedSchedules = Map<String, List<DaySchedule>>.from(result.schedules);
        sortedSchedules.forEach((day, scheduleList) {
          scheduleList.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
        });
        subjects[index] = result.copyWith(schedules: sortedSchedules);
        _saveSubjects();
      });
    }
  }

  void _deleteSubject(Subject subject) {
    setState(() {
      subjects.remove(subject);
      _saveSubjects();
    });
  }

  String _getCurrentDay() {
    final now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM d').format(now);
  }

  void _showDaySelectionDialog() async {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDay = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a Day'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: daysOfWeek.map((day) {
              // Check if any subject has classes on this day
              final hasClasses = subjects.any((subject) => subject.schedules.containsKey(day));
              return ListTile(
                title: Text(day),
                subtitle: hasClasses ? null : const Text('No classes'),
                enabled: hasClasses,
                onTap: hasClasses ? () => Navigator.pop(context, day) : null,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedDay != null && mounted) {
      setState(() {
        _tempSelectedDay = selectedDay;
        _lastSelectionDate = DateTime.now();
        _hasClassesForSelectedDay = subjects.any((subject) => subject.schedules.containsKey(selectedDay));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = _getCurrentDay();
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    // Reset _tempSelectedDay if it's a new day
    if (_lastSelectionDate != null && _lastSelectionDate!.day != today.day) {
      _tempSelectedDay = null;
      _lastSelectionDate = null;
      _hasClassesForSelectedDay = false;
    }

    // Determine which day's schedules to show
    final displayDay = _tempSelectedDay ?? currentDay;
    final subjectSchedules = <MapEntry<Subject, DaySchedule>>[];
    for (var subject in subjects) {
      if (subject.schedules.containsKey(displayDay)) {
        for (var schedule in subject.schedules[displayDay]!) {
          subjectSchedules.add(MapEntry(subject, schedule));
        }
      }
    }

    subjectSchedules.sort((a, b) {
      final aSchedule = a.value;
      final bSchedule = b.value;
      return aSchedule.startTimeInMinutes.compareTo(bSchedule.startTimeInMinutes);
    });

    // Only show the selected day if it has classes
    final effectiveDisplayDay = (_tempSelectedDay != null && !_hasClassesForSelectedDay) ? currentDay : displayDay;

    Subject? selectedSubject;
    if (_selectedSubjectName != null && subjects.isNotEmpty) {
      selectedSubject = subjects.firstWhere(
        (subject) => subject.name.trim().toLowerCase() == _selectedSubjectName!.trim().toLowerCase(),
        orElse: () => subjects.first,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getFormattedDate()),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.findAncestorStateOfType<FigmaToCodeAppState>()!._isDarkTheme
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
              color: context.findAncestorStateOfType<FigmaToCodeAppState>()!._isDarkTheme
                  ? Colors.yellow
                  : Colors.black,
            ),
            onPressed: () {
              context.findAncestorStateOfType<FigmaToCodeAppState>()!.toggleTheme();
            },
          ),
        ],
      ),
      drawer: AttendanceDrawer(
        subjects: subjects,
        minimumAttendance: _minimumAttendance,
        onMinimumAttendanceChanged: _updateMinimumAttendance,
        onOverallAttendance: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OverallAttendanceScreen(
                subjects: subjects,
                minimumAttendance: _minimumAttendance,
              ),
            ),
          );
        },
        onManageSubjects: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageSubjectsScreen(
                subjects: subjects,
                onEditSubject: _editSubject,
                onDeleteSubject: _deleteSubject,
              ),
            ),
          );
        },
        onTasks: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TasksScreen(
                tasks: tasks,
                onAddTask: _addTask,
                onTaskCompleted: _updateTaskCompletion,
              ),
            ),
          );
        },
      ),
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: IndexedStack(
          index: _bottomNavIndex,
          children: [
            TimerTab(
              subjects: subjects,
              selectedSubject: selectedSubject,
              onSubjectSelected: (Subject? subject) {
                setState(() {
                  _selectedSubjectName = subject?.name;
                  _saveSelectedSubject();
                });
              },
              onStudySessionSaved: _onStudySessionSaved,
            ),
            subjectSchedules.isEmpty && _tempSelectedDay == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No subjects scheduled for $currentDay',
                          style: TextStyle(
                            color: context
                                    .findAncestorStateOfType<FigmaToCodeAppState>()!
                                    ._isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'View classes from another day?',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add_circle, size: 24),
                              color: context
                                      .findAncestorStateOfType<FigmaToCodeAppState>()!
                                      ._isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: _showDaySelectionDialog,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: subjectSchedules.length,
                    itemBuilder: (context, index) {
                      final entry = subjectSchedules[index];
                      final subject = entry.key;
                      final schedule = entry.value;
                      final scheduleKey =
                          '${schedule.startTime.hour}:${schedule.startTime.minute}';
                      return SubjectCard(
                        subject: subject,
                        currentDay: effectiveDisplayDay,
                        schedule: schedule,
                        scheduleKey: scheduleKey,
                        minimumAttendance: _minimumAttendance,
                        currentAttendance:
                            subject.dailyAttendance[todayKey]?[scheduleKey],
                        onAttendanceChanged: (attendance, date, scheduleKey) {
                          setState(() {
                            final subjectIndex = subjects.indexOf(subject);
                            final newDailyAttendance =
                                Map<DateTime, Map<String, String>>.from(
                                    subject.dailyAttendance);

                            if (!newDailyAttendance.containsKey(date)) {
                              newDailyAttendance[date] = {};
                            }

                            newDailyAttendance[date]![scheduleKey] = attendance;

                            subjects[subjectIndex] = subject.copyWith(
                              dailyAttendance: newDailyAttendance,
                            );

                            _saveSubjects();
                          });
                        },
                      );
                    },
                  ),
            TimeTab(
              subjects: subjects,
              currentDay: currentDay,
              isDarkTheme:
                  context.findAncestorStateOfType<FigmaToCodeAppState>()!._isDarkTheme,
            ),
            TasksScreen(
              tasks: tasks,
              onAddTask: _addTask,
              onTaskCompleted: _updateTaskCompletion,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubject,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
        ],
      ),
    );
  }
}