import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunk/main.dart';
import 'package:bunk/subject.dart';
import 'package:bunk/add_subject_dialog.dart';

void main() {
  group('App Widget Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance();
    });

    testWidgets('Test subject creation and attendance tracking', (WidgetTester tester) async {
      await tester.pumpWidget(const FigmaToCodeApp(initialDarkTheme: true));

      // Test adding a new subject
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in subject details
      await tester.enterText(find.byType(TextField).first, 'Test Subject');
      await tester.pumpAndSettle();

      // Add a schedule for Monday
      await tester.tap(find.text('Mon'));
      await tester.pumpAndSettle();

      // Simulate time selection (using fixed times for testing)
      final BuildContext dialogContext = tester.element(find.byType(AddSubjectDialog));
      const TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
      const TimeOfDay endTime = TimeOfDay(hour: 10, minute: 0);

      // Add schedule with fixed times
      Navigator.of(dialogContext).pop(startTime);
      await tester.pumpAndSettle();
      Navigator.of(dialogContext).pop(endTime);
      await tester.pumpAndSettle();

      // Save the subject
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify subject was created
      expect(find.text('Test Subject'), findsOneWidget);

      // Navigate to Timer tab
      await tester.tap(find.text('Timer'));
      await tester.pumpAndSettle();

      // Verify initial timer state
      expect(find.text('00:00:00'), findsOneWidget);

      // Select subject in timer
      await tester.tap(find.byType(DropdownButton<Subject>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Subject').last);
      await tester.pumpAndSettle();

      // Start and verify timer
      await tester.tap(find.text('Start'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:00:00'), findsNothing);
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('00:00:05'), findsOneWidget);
    });

    testWidgets('Test theme switching', (WidgetTester tester) async {
      await tester.pumpWidget(const FigmaToCodeApp(initialDarkTheme: true));

      // Test initial dark theme
      final ScaffoldState darkScaffold = tester.firstState(find.byType(Scaffold));
      expect(
        darkScaffold.context.findAncestorStateOfType<FigmaToCodeAppState>()!.isDarkTheme,
        true,
      );

      // Toggle theme
      await tester.tap(find.byIcon(Icons.nightlight_round));
      await tester.pumpAndSettle();

      // Verify light theme
      final ScaffoldState lightScaffold = tester.firstState(find.byType(Scaffold));
      expect(
        lightScaffold.context.findAncestorStateOfType<FigmaToCodeAppState>()!.isDarkTheme,
        false,
      );
    });
  });
}