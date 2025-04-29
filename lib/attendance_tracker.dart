class AttendanceTracker {
  final int totalClasses;
  final int presentClasses;
  final double minimumAttendance;

  AttendanceTracker({
    required this.totalClasses,
    required this.presentClasses,
    required this.minimumAttendance,
  });

  double get attendancePercentage =>
      totalClasses > 0 ? (presentClasses / totalClasses) * 100 : 0;

  // Calculate how many classes you can bunk while keeping attendance >= minimumAttendance
  int get classesCanBunk {
    if (attendancePercentage < minimumAttendance) return 0;

    int classesCanMiss = 0;
    double currentAttendance = attendancePercentage;
    int currentTotal = totalClasses;
    int currentPresent = presentClasses;

    while (currentAttendance >= minimumAttendance) {
      currentTotal++;
      currentAttendance = (currentPresent / currentTotal) * 100;
      if (currentAttendance >= minimumAttendance) {
        classesCanMiss++;
      } else {
        break;
      }
    }

    return classesCanMiss;
  }

  // Check if you're on track (i.e., missing one more class will drop attendance below minimum)
  bool get isOnTrack {
    if (attendancePercentage < minimumAttendance) return false;

    int newTotal = totalClasses + 1;
    double newAttendance = (presentClasses / newTotal) * 100;
    return newAttendance < minimumAttendance;
  }

  // Calculate how many classes you need to attend to reach minimumAttendance
  int get classesNeededToReachMinimum {
    if (attendancePercentage >= minimumAttendance) return 0;

    int classesNeeded = 0;
    int currentTotal = totalClasses;
    int currentPresent = presentClasses;

    while ((currentPresent / currentTotal) * 100 < minimumAttendance) {
      currentTotal++;
      currentPresent++;
      classesNeeded++;
    }

    return classesNeeded;
  }

  // Get the appropriate message based on attendance status
  String get attendanceMessage {
    if (attendancePercentage >= minimumAttendance) {
      int canBunk = classesCanBunk;
      if (isOnTrack) {
        return 'You are on track';
      } else if (canBunk > 0) {
        return 'You can bunk next $canBunk classes';
      } else {
        return 'You are on track';
      }
    } else {
      int needed = classesNeededToReachMinimum;
      return 'You need to attend $needed classes to reach ${minimumAttendance.round()}%';
    }
  }
}