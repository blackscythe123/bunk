import 'package:flutter/material.dart';
import 'subject.dart';

class AddSubjectDialog extends StatefulWidget {
  final List<Subject> subjects;
  final Subject? subjectToEdit;

  const AddSubjectDialog({
    super.key,
    required this.subjects,
    this.subjectToEdit,
  });

  @override
  AddSubjectDialogState createState() => AddSubjectDialogState();
}

class AddSubjectDialogState extends State<AddSubjectDialog> {
  final _nameController = TextEditingController();
  final Map<String, List<DaySchedule>> _schedules = {};
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    if (widget.subjectToEdit != null) {
      _nameController.text = widget.subjectToEdit!.name;
      _schedules.addAll(widget.subjectToEdit!.schedules);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addScheduleForDay(String day) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Color(0xFF1C2526),
                    hourMinuteTextColor: Colors.white,
                    hourMinuteColor: Color(0xFF3A3F44),
                    dialHandColor: Colors.white,
                    dialBackgroundColor: Color(0xFF3A3F44),
                    entryModeIconColor: Colors.white,
                    helpTextStyle: TextStyle(color: Colors.white),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                )
              : ThemeData.light().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Colors.white,
                    hourMinuteTextColor: Colors.black,
                    hourMinuteColor: Colors.grey,
                    dialHandColor: Colors.black,
                    dialBackgroundColor: Colors.grey,
                    entryModeIconColor: Colors.black,
                    helpTextStyle: TextStyle(color: Colors.black),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (startTime == null || !mounted) return;

    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = startMinutes + 45;
    int endHour = (endMinutes ~/ 60) % 24;
    int endMinute = endMinutes % 60;

    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: endHour, minute: endMinute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Color(0xFF1C2526),
                    hourMinuteTextColor: Colors.white,
                    hourMinuteColor: Color(0xFF3A3F44),
                    dialHandColor: Colors.white,
                    dialBackgroundColor: Color(0xFF3A3F44),
                    entryModeIconColor: Colors.white,
                    helpTextStyle: TextStyle(color: Colors.white),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                )
              : ThemeData.light().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Colors.white,
                    hourMinuteTextColor: Colors.black,
                    hourMinuteColor: Colors.grey,
                    dialHandColor: Colors.black,
                    dialBackgroundColor: Colors.grey,
                    entryModeIconColor: Colors.black,
                    helpTextStyle: TextStyle(color: Colors.black),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (endTime == null || !mounted) return;

    final newSchedule = DaySchedule(startTime: startTime, endTime: endTime);

    bool hasOverlap = false;
    for (var subject in widget.subjects) {
      if (subject != widget.subjectToEdit && subject.schedules.containsKey(day)) {
        for (var existingSchedule in subject.schedules[day]!) {
          if (newSchedule.overlapsWith(existingSchedule)) {
            hasOverlap = true;
            break;
          }
        }
      }
      if (hasOverlap) break;
    }

    if (_schedules.containsKey(day)) {
      for (var existingSchedule in _schedules[day]!) {
        if (newSchedule.overlapsWith(existingSchedule)) {
          hasOverlap = true;
          break;
        }
      }
    }

    if (hasOverlap) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time slot overlaps with another subject. Please choose a different time.'),
          ),
        );
      }
      return;
    }

    setState(() {
      if (!_schedules.containsKey(day)) {
        _schedules[day] = [];
      }
      _schedules[day]!.add(newSchedule);
      _schedules[day]!.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
    });
  }

  void _editScheduleForDay(String day, DaySchedule schedule) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: schedule.startTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Color(0xFF1C2526),
                    hourMinuteTextColor: Colors.white,
                    hourMinuteColor: Color(0xFF3A3F44),
                    dialHandColor: Colors.white,
                    dialBackgroundColor: Color(0xFF3A3F44),
                    entryModeIconColor: Colors.white,
                    helpTextStyle: TextStyle(color: Colors.white),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                )
              : ThemeData.light().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Colors.white,
                    hourMinuteTextColor: Colors.black,
                    hourMinuteColor: Colors.grey,
                    dialHandColor: Colors.black,
                    dialBackgroundColor: Colors.grey,
                    entryModeIconColor: Colors.black,
                    helpTextStyle: TextStyle(color: Colors.black),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (startTime == null || !mounted) return;

    int startMinutes = startTime.hour * 60 + startTime.minute;
    int duration = (schedule.endTime.hour * 60 + schedule.endTime.minute) -
        (schedule.startTime.hour * 60 + schedule.startTime.minute);
    int endMinutes = startMinutes + duration;
    int endHour = (endMinutes ~/ 60) % 24;
    int endMinute = endMinutes % 60;

    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: endHour, minute: endMinute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Color(0xFF1C2526),
                    hourMinuteTextColor: Colors.white,
                    hourMinuteColor: Color(0xFF3A3F44),
                    dialHandColor: Colors.white,
                    dialBackgroundColor: Color(0xFF3A3F44),
                    entryModeIconColor: Colors.white,
                    helpTextStyle: TextStyle(color: Colors.white),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                )
              : ThemeData.light().copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Colors.white,
                    hourMinuteTextColor: Colors.black,
                    hourMinuteColor: Colors.grey,
                    dialHandColor: Colors.black,
                    dialBackgroundColor: Colors.grey,
                    entryModeIconColor: Colors.black,
                    helpTextStyle: TextStyle(color: Colors.black),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (endTime == null || !mounted) return;

    final newSchedule = DaySchedule(startTime: startTime, endTime: endTime);

    bool hasOverlap = false;
    for (var subject in widget.subjects) {
      if (subject != widget.subjectToEdit && subject.schedules.containsKey(day)) {
        for (var existingSchedule in subject.schedules[day]!) {
          if (newSchedule.overlapsWith(existingSchedule)) {
            hasOverlap = true;
            break;
          }
        }
      }
      if (hasOverlap) break;
    }

    if (_schedules.containsKey(day)) {
      for (var existingSchedule in _schedules[day]!) {
        if (existingSchedule != schedule && newSchedule.overlapsWith(existingSchedule)) {
          hasOverlap = true;
          break;
        }
      }
    }

    if (hasOverlap) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time slot overlaps with another schedule. Please choose a different time.'),
          ),
        );
      }
      return;
    }

    setState(() {
      final index = _schedules[day]!.indexOf(schedule);
      _schedules[day]![index] = newSchedule;
      _schedules[day]!.sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subjectToEdit != null ? 'Edit Subject' : 'Add Subject'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Subject Name',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Schedules:'),
            ..._days.map((day) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(day),
                      subtitle: _schedules.containsKey(day) && _schedules[day]!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _schedules[day]!.map((schedule) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${schedule.startTime.format(context)} - ${schedule.endTime.format(context)}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 20),
                                          onPressed: () => _editScheduleForDay(day, schedule),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, size: 20),
                                          onPressed: () {
                                            int totalSchedules = _schedules.values.fold(
                                                0, (sum, list) => sum + list.length);
                                            if (totalSchedules == 1) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'You must have at least one schedule for the subject.'),
                                                ),
                                              );
                                              return;
                                            }
                                            setState(() {
                                              _schedules[day]!.remove(schedule);
                                              if (_schedules[day]!.isEmpty) {
                                                _schedules.remove(day);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          : const Text('No schedule'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addScheduleForDay(day),
                      ),
                    ),
                  ],
                )),
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
            if (_nameController.text.isNotEmpty && _schedules.isNotEmpty) {
              Navigator.pop(
                context,
                Subject(
                  name: _nameController.text,
                  schedules: _schedules,
                  dailyAttendance: widget.subjectToEdit?.dailyAttendance ?? {},
                  studyStats: widget.subjectToEdit?.studyStats ??
                      StudyStats(totalMinutes: 0, sessions: 0),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a subject name and at least one schedule'),
                ),
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}