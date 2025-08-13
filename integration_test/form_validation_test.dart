import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Form Validation Tests', () {
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
      
      print('Test 1 passed: Validation error shown when only First Name is set');
    });
  });
}