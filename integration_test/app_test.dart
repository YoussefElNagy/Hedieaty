import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedeyeti/components/(auth)/LoginScreen.dart';
import 'package:hedeyeti/components/myevents/MyEvents.dart';
import 'package:hedeyeti/components/myfriends/Home.dart';
import 'package:hedeyeti/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("end_to_end", () {
    firebaseInit();

    // Navbar Test without main application
    testWidgets('BottomNavigationBar', (tester) async {
      // Build the app
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Select Navbar Item
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify the expected result
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.card_giftcard));
      await tester.pumpAndSettle();

      // Verify the expected result
      expect(find.text('My Gifts'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_calendar_rounded));
      await tester.pumpAndSettle();

      // Verify the expected result
      expect(find.text('My Events'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();

      // Verify the expected result
      expect(find.text('Upcoming Events'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.group));
      await tester.pumpAndSettle();

      // Verify the expected result
      expect(find.text('Friends'), findsOneWidget);
    });

    testWidgets("loginFail", (tester) async {
      await tester.pumpWidget(Hedieaty());
      await tester.enterText(
          find.byType(TextFormField).at(0), "nognogg@gmail.com");
      await tester.enterText(find.byType(TextFormField).at(1), "abc");
      await tester.pump(); //setState
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(TextButton), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), "nognogg");
      await tester.enterText(find.byType(TextFormField).at(1), "");
      await tester.pump(); //setState
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));

      //check if in sign in
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets("loginSuccess", (tester) async {
      await tester.pumpWidget(Hedieaty());
      await tester.enterText(
          find.byType(TextFormField).at(0), "nognog@gmail.com");
      await tester.enterText(find.byType(TextFormField).at(1), "nognog");
      await tester.pump(); //setState
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));

      //check if in home
      expect(find.byIcon(Icons.person_add), findsOneWidget);
    });

    // testWidgets('Create Event', (WidgetTester tester) async {
    //   // Build the widget
    //   await tester.pumpWidget(MaterialApp(home: MyEvents()));
    //
    //   // Verify the FloatingActionButton exists
    //   expect(find.byType(FloatingActionButton), findsOneWidget);
    //
    //   // Tap the FloatingActionButton
    //   await tester.tap(find.byType(FloatingActionButton));
    //   await tester.pumpAndSettle();
    //
    //   // Verify the dialog appears
    //   expect(find.byKey(const Key('eventDialog')), findsOneWidget);
    //
    //   // Verify form fields and buttons exist
    //   expect(find.widgetWithText(TextField, 'Event Name'), findsOneWidget);
    //   expect(find.widgetWithText(TextField, 'Date & Time (yyyy-MM-dd HH:mm)'),
    //       findsOneWidget);
    //   expect(find.widgetWithText(TextField, 'Event Location'), findsOneWidget);
    //   expect(find.byKey(const Key('eventDropDown')), findsOneWidget);
    //   expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    //   expect(find.widgetWithText(ElevatedButton, 'Create'), findsOneWidget);
    //
    //   // Fill out the form fields
    //   await tester.enterText(
    //       find.widgetWithText(TextField, 'Event Name'), 'Integration Party');
    //   await tester.enterText(
    //       find.widgetWithText(TextField, 'Date & Time (yyyy-MM-dd HH:mm)'),
    //       '2024-12-25 18:00');
    //   await tester.enterText(
    //       find.widgetWithText(TextField, 'Event Location'), 'My House');
    //
    //   // Select a category from the dropdown
    //   await tester.tap(find.byKey(const Key('eventDropDown')));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('engagement').last);
    //   await tester.pumpAndSettle();
    //
    //   // Tap the Create button
    //   await tester.tap(find.widgetWithText(ElevatedButton, 'Create'));
    //   await tester.pumpAndSettle();
    //
    //   // Verify that the dialog is closed
    //   expect(find.byKey(const Key('createEventDialog')), findsNothing);
    //   await tester.pumpAndSettle(Duration(seconds: 5));
    //   expect(find.widgetWithText(ListTile,'Integration Party'), findsOneWidget);
    //
    // });

    testWidgets('Create and Delete Event', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(MaterialApp(home: MyEvents()));

      // Verify the FloatingActionButton exists
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap the FloatingActionButton to open the event creation dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify the dialog appears
      expect(find.byKey(const Key('eventDialog')), findsOneWidget);

      // Verify form fields and buttons exist
      expect(find.widgetWithText(TextField, 'Event Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Date & Time (yyyy-MM-dd HH:mm)'),
          findsOneWidget);
      expect(find.widgetWithText(TextField, 'Event Location'), findsOneWidget);
      expect(find.byKey(const Key('eventDropDown')), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Create'), findsOneWidget);

      // Fill out the form fields
      await tester.enterText(
          find.widgetWithText(TextField, 'Event Name'), 'Integration Party');
      await tester.enterText(
          find.widgetWithText(TextField, 'Date & Time (yyyy-MM-dd HH:mm)'),
          '2024-12-25 18:00');
      await tester.enterText(
          find.widgetWithText(TextField, 'Event Location'), 'My House');

      // Select a category from the dropdown
      await tester.tap(find.byKey(const Key('eventDropDown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('engagement').last);
      await tester.pumpAndSettle();

      // Tap the Create button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create'));
      await tester.pumpAndSettle();

      // Verify that the dialog is closed and the event is added to the list
      expect(find.byKey(const Key('createEventDialog')), findsNothing);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Find the ListTile for "Integration Party" and verify it's added to the list
      final integrationPartyTile =
          find.widgetWithText(ListTile, 'Integration Party');
      expect(integrationPartyTile, findsOneWidget);

      // Now test deleting the event
      // Find the delete icon in the "Integration Party" ListTile and tap it
      final deleteButton = find.descendant(
        of: integrationPartyTile,
        matching: find.byIcon(Icons.delete),
      );
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify the confirmation dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify that the event is deleted from the list
      expect(find.widgetWithText(ListTile, 'Integration Party'), findsNothing);
    });
  });
}
