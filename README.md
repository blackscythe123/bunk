# Bunk Attendance & Study Tracker 📚

## Project Overview

**Bunk** is a modern Flutter application designed for students to efficiently track class attendance, manage study sessions, and organize academic tasks. With a clean interface and powerful features, Bunk helps you stay on top of your academic commitments, visualize attendance statistics, and optimize your study habits.

## Key Features

- **Attendance Tracking**: Mark attendance for each subject and session, with daily and per-class granularity.
- **Schedule Management**: Add, edit, and delete subjects with custom class schedules for each weekday.
- **Study Timer**: Built-in timer to track focused study sessions per subject, with statistics.
- **Analytics & Visualization**: Visualize attendance with charts and progress indicators.
- **Minimum Attendance Setting**: Set and adjust required attendance percentage for compliance.
- **Task Management**: Add, complete, and track academic tasks and to-dos.
- **Theme Support**: Light and dark themes with persistent user preference.
- **Persistent Storage**: All data is saved locally using `shared_preferences`.
- **User-Friendly UI**: Material Design, responsive layouts, and intuitive navigation.

## Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Stateful Widgets
- **Persistence**: shared_preferences
- **Charts & Visualization**: fl_chart, wave
- **Date/Time Handling**: intl
- **Other**: path_provider, csv

## Project Structure

```
bunk/
├── lib/
│   ├── main.dart                  # App entry point, navigation, and state
│   ├── subject.dart               # Subject model and attendance logic
│   ├── attendance_drawer.dart     # Drawer with navigation and analytics
│   ├── manage_subjects_screen.dart# Manage subjects (add/edit/delete)
│   ├── add_subject_dialog.dart    # Dialog for adding/editing subjects
│   ├── subject_card.dart          # UI for displaying subject info
│   ├── timer_tab.dart             # Study timer and statistics
│   ├── time_tab.dart              # Weekly schedule view
│   ├── tasks.dart                 # Task management screen
│   └── ... (other Dart files)
├── assets/
│   ├── icon/
│   │   └── icon.png               # App icon
│   └── fonts/
│       └── NotoSans-*.ttf         # App fonts
├── pubspec.yaml                   # Flutter dependencies and assets
└── README.md                      # This file
```

## Installation & Setup

### Prerequisites

- Flutter SDK (3.7.0+ recommended)
- Dart SDK
- Android Studio / VS Code (with Flutter plugin)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/bunk.git
   cd bunk
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```
   You can run on an emulator or a connected device.

## Configuration

All configuration is handled via `pubspec.yaml` for dependencies and assets. No backend or external API keys are required.

## Main Screens & Navigation

- **Today**: View and mark attendance for today's classes.
- **Schedule**: See the weekly timetable for all subjects.
- **Timer**: Track focused study sessions per subject.
- **Tasks**: Manage academic tasks and to-dos.
- **Drawer**: Access overall attendance analytics, manage subjects, set minimum attendance, and view all subjects.

## Data Persistence

- All user data (subjects, attendance, tasks, preferences) is stored locally using `shared_preferences`.
- No internet connection is required for core features.

## Customization

- **Themes**: Toggle between light and dark mode from the app bar.
- **Attendance Requirement**: Set your minimum required attendance percentage.

## Development & Contribution

- Fork and clone the repository.
- Use feature branches for new features or bug fixes.
- Submit pull requests for review.

## License

For questions or support, contact the development team at [samsamuel234567@gmail.com].
