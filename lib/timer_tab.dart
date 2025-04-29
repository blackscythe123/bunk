import 'package:flutter/material.dart';
import 'dart:async';
import 'subject.dart';

class TimerTab extends StatefulWidget {
  final List<Subject> subjects;
  final Subject? selectedSubject;
  final Function(Subject?) onSubjectSelected;
  final VoidCallback onStudySessionSaved;

  const TimerTab({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
    required this.onStudySessionSaved,
  });

  @override
  TimerTabState createState() => TimerTabState();
}

class TimerTabState extends State<TimerTab> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  late List<Subject> _subjects;

  @override
  void initState() {
    super.initState();
    _subjects = widget.subjects;
  }

  @override
  void didUpdateWidget(TimerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjects != oldWidget.subjects) {
      setState(() {
        _subjects = widget.subjects;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject first')),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = true;
      });
    }
  }

  void _resumeTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });

    if (widget.selectedSubject != null && _seconds > 0) {
      final sessionMinutes = _seconds / 60.0;
      final subjectIndex = widget.subjects.indexOf(widget.selectedSubject!);
      final updatedStats = widget.selectedSubject!.studyStats.copyWith(
        totalMinutes: widget.selectedSubject!.studyStats.totalMinutes + sessionMinutes,
        sessions: widget.selectedSubject!.studyStats.sessions + 1,
      );

      setState(() {
        widget.subjects[subjectIndex] = widget.selectedSubject!.copyWith(studyStats: updatedStats);
        _subjects = widget.subjects;
        _seconds = 0;
      });

      widget.onStudySessionSaved();
    } else {
      setState(() {
        _seconds = 0;
      });
    }
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    // Safely handle selectedSubject
    Subject? selectedSubject = widget.selectedSubject;
    if (selectedSubject != null && _subjects.isNotEmpty) {
      selectedSubject = _subjects.firstWhere(
        (subject) => subject.name == selectedSubject!.name,
        orElse: () => selectedSubject!,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF3A3F44)
                  : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<Subject>(
                isExpanded: true,
                value: selectedSubject,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                ),
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1C2526)
                  : Colors.white,
                hint: const Text('Select a subject'),
                items: widget.subjects.map((Subject subject) {
                  return DropdownMenuItem<Subject>(
                    value: subject,
                    child: Text(
                      subject.name,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Subject? newValue) {
                  widget.onSubjectSelected(newValue);
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            _formatTime(_seconds),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning || _isPaused ? _stopTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning || _isPaused 
                    ? const Color(0xFFE57373)
                    : const Color(0xFF81C784),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  _isRunning || _isPaused ? 'Stop' : 'Start',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isRunning
                  ? _pauseTimer
                  : (_isPaused ? _resumeTimer : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  _isPaused ? 'Resume' : 'Pause',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Add null check for selectedSubject
          selectedSubject == null
            ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1C2526)
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No subject selected',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1C2526)
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Study Time: ${selectedSubject.studyStats.totalMinutes.toStringAsFixed(1)} minutes',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Sessions: ${selectedSubject.studyStats.sessions}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

