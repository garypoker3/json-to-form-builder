import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('JSON to Form Builder Integration Tests', () {
    
    testWidgets('Test 1: Only First Name set shows validation error on Submit', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the form fields
      final firstNameField = find.byKey(const ValueKey('firstName'));
      final submitButton = find.text('Submit');

      // Enter only First Name
      await tester.enterText(firstNameField, 'John');
      await tester.pumpAndSettle();

      // Tap Submit button
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify validation error is shown (should show error for Last Name and Email)
      expect(find.text('Please fix form errors'), findsOneWidget);
      
      // Verify snackbar with error message appears
      expect(find.byType(SnackBar), findsOneWidget);
      
      print('✅ Test 1 passed: Validation error shown when only First Name is set');
    });

    testWidgets('Test 2: Resident toggle off disables Subscribe checkbox', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the resident toggle and subscribe checkbox
      final residentToggle = find.byKey(const ValueKey('resident'));
      final subscribeCheckbox = find.byKey(const ValueKey('subscribe'));

      // Verify initial state: resident toggle should be ON (true), subscribe should be enabled
      FormBuilderSwitch residentSwitch = tester.widget(residentToggle);
      expect(residentSwitch.initialValue, isTrue, reason: 'Resident toggle should be ON by default');

      // Verify subscribe checkbox is initially enabled
      FormBuilderCheckbox subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.enabled, isTrue, reason: 'Subscribe checkbox should be enabled initially');

      // Tap the resident toggle to turn it OFF
      await tester.tap(residentToggle);
      await tester.pumpAndSettle();

      // After toggle, verify the checkbox state changes
      subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.enabled, isFalse, reason: 'Subscribe checkbox should be disabled when resident is OFF');

      // Tap resident toggle again to turn it back ON
      await tester.tap(residentToggle);
      await tester.pumpAndSettle();

      // Verify subscribe checkbox is enabled again
      subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.enabled, isTrue, reason: 'Subscribe checkbox should be enabled when resident is ON');

      print('✅ Test 2 passed: Resident toggle properly controls subscribe checkbox accessibility');
    });

    testWidgets('Test 3: Reset button restores all fields to default values', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find all form fields and buttons
      final firstNameField = find.byKey(const ValueKey('firstName'));
      final lastNameField = find.byKey(const ValueKey('lastName'));
      final emailField = find.byKey(const ValueKey('email'));
      final ageField = find.byKey(const ValueKey('age'));
      final genderDropdown = find.byKey(const ValueKey('gender'));
      final subscribeCheckbox = find.byKey(const ValueKey('subscribe'));
      final residentToggle = find.byKey(const ValueKey('resident'));
      final resetButton = find.text('Reset');

      // First, turn OFF the resident toggle
      await tester.tap(residentToggle);
      await tester.pumpAndSettle();

      // Fill out all the form fields with test values
      await tester.enterText(firstNameField, 'John');
      await tester.enterText(lastNameField, 'Doe');
      await tester.enterText(emailField, 'john.doe@example.com');
      await tester.enterText(ageField, '30');
      
      // Select gender dropdown option
      await tester.tap(genderDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Male').last);
      await tester.pumpAndSettle();

      // Wait a moment to ensure all fields are filled
      await tester.pump();

      // Verify that we can read the field values (they should be filled)
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);

      // Now tap the Reset button
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Verify all fields have been reset to their default values by checking they no longer contain the values
      expect(find.text('John'), findsNothing, reason: 'First Name should be empty after reset');
      expect(find.text('Doe'), findsNothing, reason: 'Last Name should be empty after reset');
      expect(find.text('john.doe@example.com'), findsNothing, reason: 'Email should be empty after reset');
      expect(find.text('30'), findsNothing, reason: 'Age should be empty after reset');

      // Verify subscribe checkbox is enabled again (since resident should be back to ON default)
      FormBuilderCheckbox subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.enabled, isTrue, reason: 'Subscribe checkbox should be enabled after reset');

      print('✅ Test 3 passed: Reset button properly restores all fields to default values');
    });

    testWidgets('Bonus Test: Full form validation with all fields', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find all form fields
      final firstNameField = find.byKey(const ValueKey('firstName'));
      final lastNameField = find.byKey(const ValueKey('lastName'));
      final emailField = find.byKey(const ValueKey('email'));
      final ageField = find.byKey(const ValueKey('age'));
      final genderDropdown = find.byKey(const ValueKey('gender'));
      final subscribeCheckbox = find.byKey(const ValueKey('subscribe'));
      final residentToggle = find.byKey(const ValueKey('resident'));
      final submitButton = find.text('Submit');

      // Fill out all required fields correctly
      await tester.enterText(firstNameField, 'Jane');
      await tester.enterText(lastNameField, 'Smith');
      await tester.enterText(emailField, 'jane.smith@example.com');
      await tester.enterText(ageField, '25');
      
      // Select gender
      await tester.tap(genderDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Female').last);
      await tester.pumpAndSettle();

      // Check the subscribe checkbox (resident should be ON by default)
      await tester.tap(subscribeCheckbox);
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify success message appears
      expect(find.text('Form submitted successfully!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      print('✅ Bonus Test passed: Complete form submission successful');
    });
  });
}