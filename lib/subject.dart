import 'package:flutter/material.dart';

class Subject {
  final String name;
  final Map<String, List<DaySchedule>> schedules;
  final Map<DateTime, Map<String, String>> dailyAttendance;
  final StudyStats studyStats;

  Subject({
    required this.name,
    required this.schedules,
    Map<DateTime, Map<String, String>>? dailyAttendance,
    StudyStats? studyStats,
  })  : dailyAttendance = dailyAttendance ?? {},
        studyStats = studyStats ?? StudyStats(totalMinutes: 0, sessions: 0);

  Subject copyWith({
    Map<String, List<DaySchedule>>? schedules,
    Map<DateTime, Map<String, String>>? dailyAttendance,
    StudyStats? studyStats,
  }) {
    return Subject(
      name: name,
      schedules: schedules ?? this.schedules,
      dailyAttendance: dailyAttendance ?? this.dailyAttendance,
      studyStats: studyStats ?? this.studyStats,
    );
  }

  int get totalClasses {
    int total = 0;
    for (var dateEntry in dailyAttendance.entries) {
      for (var scheduleEntry in dateEntry.value.entries) {
        if (scheduleEntry.value == 'Present' || scheduleEntry.value == 'Absent') {
          total++;
        }
      }
    }
    return total;
  }

  int get presentClasses {
    int present = 0;
    for (var dateEntry in dailyAttendance.entries) {
      for (var scheduleEntry in dateEntry.value.entries) {
        if (scheduleEntry.value == 'Present') {
          present++;
        }
      }
    }
    return present;
  }

  double get attendancePercentage => totalClasses > 0 ? (presentClasses / totalClasses) * 100 : 0;

  String getAttendanceForDateAndSchedule(DateTime date, String scheduleKey) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return dailyAttendance[dateKey]?[scheduleKey] ?? 'No Class';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'schedules': schedules.map((day, scheduleList) => MapEntry(
            day,
            scheduleList.map((schedule) => {
                  'startTime': {'hour': schedule.startTime.hour, 'minute': schedule.startTime.minute},
                  'endTime': {'hour': schedule.endTime.hour, 'minute': schedule.endTime.minute},
                }).toList(),
          )),
      'dailyAttendance': dailyAttendance.map((date, attendanceMap) => MapEntry(
            date.toIso8601String(),
            attendanceMap,
          )),
      'studyStats': {
        'totalMinutes': studyStats.totalMinutes,
        'sessions': studyStats.sessions,
      },
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      schedules: (json['schedules'] as Map<String, dynamic>).map((day, scheduleList) {
        return MapEntry(
          day,
          (scheduleList as List<dynamic>).map((scheduleJson) {
            return DaySchedule(
              startTime: TimeOfDay(
                hour: scheduleJson['startTime']['hour'],
                minute: scheduleJson['startTime']['minute'],
              ),
              endTime: TimeOfDay(
                hour: scheduleJson['endTime']['hour'],
                minute: scheduleJson['endTime']['minute'],
              ),
            );
          }).toList(),
        );
      }),
      dailyAttendance: (json['dailyAttendance'] as Map<String, dynamic>?)?.map((dateString, attendanceMap) {
            return MapEntry(
              DateTime.parse(dateString),
              Map<String, String>.from(attendanceMap),
            );
          }) ??
          {},
      studyStats: StudyStats(
        totalMinutes: (json['studyStats']?['totalMinutes'] as num?)?.toDouble() ?? 0,
        sessions: (json['studyStats']?['sessions'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject && other.name.trim().toLowerCase() == name.trim().toLowerCase();
  }

  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}

class StudyStats {
  final double totalMinutes;
  final int sessions;

  StudyStats({required this.totalMinutes, required this.sessions});

  StudyStats copyWith({double? totalMinutes, int? sessions}) {
    return StudyStats(
      totalMinutes: totalMinutes ?? this.totalMinutes,
      sessions: sessions ?? this.sessions,
    );
  }
}

class DaySchedule {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  DaySchedule({required this.startTime, required this.endTime});

  int get startTimeInMinutes => startTime.hour * 60 + startTime.minute;
  int get endTimeInMinutes => endTime.hour * 60 + endTime.minute;

  bool overlapsWith(DaySchedule other) {
    return startTimeInMinutes < other.endTimeInMinutes && endTimeInMinutes > other.startTimeInMinutes;
  }
}