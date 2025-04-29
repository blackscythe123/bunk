import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'subject.dart';

class SubjectCard extends StatefulWidget {
  final Subject subject;
  final String currentDay;
  final DaySchedule schedule;
  final String scheduleKey;
  final double minimumAttendance;
  final Function(String, DateTime, String) onAttendanceChanged;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.currentDay,
    required this.schedule,
    required this.scheduleKey,
    required this.minimumAttendance,
    required this.onAttendanceChanged, String? currentAttendance,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  String? _selectedStatus;

  void _markAttendance(String status) {
    setState(() {
      _selectedStatus = status;
    });
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    widget.onAttendanceChanged(status, todayKey, widget.scheduleKey);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleText =
        '${widget.schedule.startTime.format(context)} - ${widget.schedule.endTime.format(context)}';

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromRGBO(135, 206, 235, 0.8)
          : const Color.fromRGBO(135, 206, 235, 1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.subject.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                              color: widget.subject.attendancePercentage >=
                                      widget.minimumAttendance
                                  ? Colors.green[700]!
                                  : Colors.red[700]!,
                              value: widget.subject.attendancePercentage,
                              radius: 8,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: Colors.grey[300]!,
                              value: 100 - widget.subject.attendancePercentage,
                              radius: 8,
                              showTitle: false,
                            ),
                          ],
                          sectionsSpace: 0,
                          centerSpaceRadius: 15,
                        ),
                      ),
                      Text(
                        '${widget.subject.attendancePercentage.round()}%',
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
            const SizedBox(height: 8),
            Text(
              'Schedule: $scheduleText',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Attendance: ${widget.subject.presentClasses}/${widget.subject.totalClasses}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _markAttendance('Present'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    elevation: _selectedStatus == 'Present' ? 10 : 4,
                    shadowColor: _selectedStatus == 'Present'
                        ? Colors.green[200]
                        : null,
                  ),
                  child: const Text('Present'),
                ),
                ElevatedButton(
                  onPressed: () => _markAttendance('Absent'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    elevation: _selectedStatus == 'Absent' ? 10 : 4,
                    shadowColor: _selectedStatus == 'Absent'
                        ? Colors.red[200]
                        : null,
                  ),
                  child: const Text('Absent'),
                ),
                ElevatedButton(
                  onPressed: () => _markAttendance('No Class'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    elevation: _selectedStatus == 'No Class' ? 10 : 4,
                    shadowColor: _selectedStatus == 'No Class'
                        ? Colors.yellow[200]
                        : null,
                  ),
                  child: const Text('No Class'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}