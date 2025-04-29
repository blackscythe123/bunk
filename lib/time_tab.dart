import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'subject.dart';

class TimeTab extends StatefulWidget {
  final List<Subject> subjects;
  final String currentDay;
  final bool isDarkTheme;

  const TimeTab({
    super.key,
    required this.subjects,
    required this.currentDay,
    required this.isDarkTheme,
  });

  @override
  TimeTabState createState() => TimeTabState();
}

class TimeTabState extends State<TimeTab> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _dayKeys = {};
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (var day in days) {
      _dayKeys[day] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolled && widget.subjects.isNotEmpty) {
        _scrollToCurrentDay(context);
        _hasScrolled = true;
      }
    });

    return widget.subjects.isEmpty
        ? const Center(child: Text('No subjects added yet'))
        : SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.currentDay == 'Sat') ..._buildDaySchedule(context, 'Sat', true),
                ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  if (day == 'Sat' && widget.currentDay == 'Sat') {
                    return <Widget>[const SizedBox.shrink()];
                  }
                  return _buildDaySchedule(context, day, day == widget.currentDay);
                }).expand((widgets) => widgets),
              ],
            ),
          );
  }

  List<Widget> _buildDaySchedule(BuildContext context, String day, bool isToday) {
    final daySubjectSchedules = <MapEntry<Subject, DaySchedule>>[];
    for (var subject in widget.subjects) {
      if (subject.schedules.containsKey(day)) {
        for (var schedule in subject.schedules[day]!) {
          daySubjectSchedules.add(MapEntry(subject, schedule));
        }
      }
    }

    daySubjectSchedules.sort((a, b) {
      final aTime = a.value.startTime;
      final bTime = b.value.startTime;

      final aHour = aTime.hour;
      final aMinute = aTime.minute;
      final bHour = bTime.hour;
      final bMinute = bTime.minute;

      if (aHour != bHour) {
        if (aHour == 12 && bHour != 12) return aTime.period == DayPeriod.am ? -1 : 1;
        if (bHour == 12 && aHour != 12) return bTime.period == DayPeriod.am ? 1 : -1;
        if (aTime.period == DayPeriod.am && bTime.period == DayPeriod.pm) return -1;
        if (aTime.period == DayPeriod.pm && bTime.period == DayPeriod.am) return 1;
        return aHour.compareTo(bHour);
      }
      return aMinute.compareTo(bMinute);
    });

    return [
      Padding(
        key: _dayKeys[day],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isToday ? '$day (Today)' : day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.yellow : null,
              ),
            ),
            const SizedBox(height: 8),
            daySubjectSchedules.isEmpty
                ? const Text('No classes scheduled')
                : Column(
                    children: daySubjectSchedules.map((entry) {
                      final subject = entry.key;
                      final schedule = entry.value;
                      final startTime = DateFormat('h:mm a').format(
                        DateTime(0, 1, 1, schedule.startTime.hour, schedule.startTime.minute),
                      );
                      final endTime = DateFormat('h:mm a').format(
                        DateTime(0, 1, 1, schedule.endTime.hour, schedule.endTime.minute),
                      );
                      return Card(
                        child: ListTile(
                          title: Text(subject.name),
                          subtitle: Text('$startTime - $endTime'),
                        ),
                      );
                    }).toList(),
                  ),
            const Divider(),
          ],
        ),
      ),
    ];
  }

  void _scrollToCurrentDay(BuildContext context) {
    final key = _dayKeys[widget.currentDay];
    if (key != null && key.currentContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox? renderBox = key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero).dy;
          final screenHeight = MediaQuery.of(context).size.height;
          final paddingTop = MediaQuery.of(context).padding.top;
          final targetOffset = position - (screenHeight / 2) + (paddingTop / 2);

          // Clamp to ensure we don't scroll beyond bounds
          final maxScrollExtent = _scrollController.position.maxScrollExtent;
          final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

          // Center the view, adjusting for content height
          _scrollController.animateTo(
            clampedOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }
}