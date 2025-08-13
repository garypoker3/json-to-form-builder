import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Reset Button Tests', () {
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

      // Verify resident toggle is OFF (we turned it off)
      Switch residentSwitch = tester.widget(residentToggle) as Switch;
      expect(residentSwitch.value, isFalse, reason: 'Resident toggle should be OFF');

      // Verify all fields have been filled
      expect((tester.widget(firstNameField) as TextField).controller?.text, equals('John'));
      expect((tester.widget(lastNameField) as TextField).controller?.text, equals('Doe'));
      expect((tester.widget(emailField) as TextField).controller?.text, equals('john.doe@example.com'));
      expect((tester.widget(ageField) as TextField).controller?.text, equals('30'));

      // Now tap the Reset button
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Verify all fields have been reset to their default values
      expect((tester.widget(firstNameField) as TextField).controller?.text, isEmpty, reason: 'First Name should be empty after reset');
      expect((tester.widget(lastNameField) as TextField).controller?.text, isEmpty, reason: 'Last Name should be empty after reset');
      expect((tester.widget(emailField) as TextField).controller?.text, isEmpty, reason: 'Email should be empty after reset');
      expect((tester.widget(ageField) as TextField).controller?.text, isEmpty, reason: 'Age should be empty after reset');

      // Verify resident toggle is back to default ON state
      residentSwitch = tester.widget(residentToggle) as Switch;
      expect(residentSwitch.value, isTrue, reason: 'Resident toggle should be ON (default) after reset');

      // Verify subscribe checkbox is enabled again (since resident is back to ON)
      Checkbox subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.onChanged, isNotNull, reason: 'Subscribe checkbox should be enabled after reset');

      print('Test 3 passed: Reset button properly restores all fields to default values');
    });
  });
}