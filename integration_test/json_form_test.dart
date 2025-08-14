import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('JSON Form Generator Tests', () {
    
    testWidgets('Load JSON from file and verify form creation with groups', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Read the JSON file
      final jsonFile = File('integration_test/json_files/security_settings_form.json');
      final jsonContent = await jsonFile.readAsString();

      // Find the JSON input field (first TextField - the one with larger content)
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.pumpAndSettle();
      
      // Clear existing content and enter new JSON
      await tester.enterText(jsonTextField, jsonContent);
      await tester.pumpAndSettle();

      // Tap the Generate Form button
      final generateButton = find.text('Generate Form');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Verify form title is displayed
      expect(find.text('Security Settings Configuration'), findsOneWidget);

      // Verify grouped fields are created with proper group labels
      expect(find.text('Account Information'), findsOneWidget);
      expect(find.text('Security Features'), findsOneWidget);
      expect(find.text('Additional Notes'), findsOneWidget);

      // Verify all 8 fields are created
      expect(find.byKey(const ValueKey('username')), findsOneWidget);
      expect(find.byKey(const ValueKey('email')), findsOneWidget);
      expect(find.byKey(const ValueKey('twoFactorAuth')), findsOneWidget);
      expect(find.byKey(const ValueKey('biometricLogin')), findsOneWidget);
      expect(find.byKey(const ValueKey('smsNotifications')), findsOneWidget);
      expect(find.byKey(const ValueKey('sessionTimeout')), findsOneWidget);
      expect(find.byKey(const ValueKey('deviceTracking')), findsOneWidget);
      expect(find.byKey(const ValueKey('notes')), findsOneWidget);

      // Verify default values are set
      final twoFactorAuthToggle = find.byKey(const ValueKey('twoFactorAuth'));
      FormBuilderSwitch twoFactorSwitch = tester.widget(twoFactorAuthToggle);
      expect(twoFactorSwitch.initialValue, isTrue, reason: 'Two-Factor Auth should be ON by default');

      final smsNotificationsToggle = find.byKey(const ValueKey('smsNotifications'));
      FormBuilderSwitch smsSwitch = tester.widget(smsNotificationsToggle);
      expect(smsSwitch.initialValue, isTrue, reason: 'SMS Notifications should be ON by default');

      // Verify default text in notes field
      final notesField = find.byKey(const ValueKey('notes'));
      FormBuilderTextField notesWidget = tester.widget(notesField);
      expect(notesWidget.initialValue, equals('Please review these settings regularly for optimal security.'));

      print('✅ Form created successfully with 8 fields in 3 groups');
    });

    testWidgets('Verify complex toggle dependencies and mutual exclusion', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonFile = File('integration_test/json_files/security_settings_form.json');
      final jsonContent = await jsonFile.readAsString();
      
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      // Find toggle controls
      final twoFactorAuthToggle = find.byKey(const ValueKey('twoFactorAuth'));
      final biometricLoginToggle = find.byKey(const ValueKey('biometricLogin'));
      final smsNotificationsToggle = find.byKey(const ValueKey('smsNotifications'));
      final sessionTimeoutToggle = find.byKey(const ValueKey('sessionTimeout'));
      final deviceTrackingToggle = find.byKey(const ValueKey('deviceTracking'));

      // Verify initial state: SMS is ON by default, Biometric is OFF
      FormBuilderSwitch smsSwitch = tester.widget(smsNotificationsToggle);
      expect(smsSwitch.initialValue, isTrue, reason: 'SMS should be ON by default');

      FormBuilderSwitch biometricSwitch = tester.widget(biometricLoginToggle);
      expect(biometricSwitch.initialValue, isFalse, reason: 'Biometric should be OFF by default');

      // Session Timeout should be disabled because SMS is ON
      FormBuilderSwitch sessionSwitch = tester.widget(sessionTimeoutToggle);
      expect(sessionSwitch.enabled, isFalse, reason: 'Session Timeout should be disabled when SMS is ON');

      // Device Tracking should be enabled because Biometric is OFF
      FormBuilderSwitch deviceSwitch = tester.widget(deviceTrackingToggle);
      expect(deviceSwitch.enabled, isTrue, reason: 'Device Tracking should be enabled when Biometric is OFF');

      // TEST MUTUAL EXCLUSION: Turn ON Biometric Login
      await tester.ensureVisible(biometricLoginToggle);
      await tester.tap(biometricLoginToggle);
      await tester.pumpAndSettle();

      // Verify SMS automatically turned OFF (mutual exclusion)
      // We need to wait a moment for the state change to propagate
      await tester.pump(const Duration(milliseconds: 100));

      // Session Timeout should now be enabled (because SMS is OFF)
      sessionSwitch = tester.widget(sessionTimeoutToggle);
      expect(sessionSwitch.enabled, isTrue, reason: 'Session Timeout should be enabled when SMS is OFF');

      // Device Tracking should now be disabled (because Biometric is ON)
      deviceSwitch = tester.widget(deviceTrackingToggle);
      expect(deviceSwitch.enabled, isFalse, reason: 'Device Tracking should be disabled when Biometric is ON');

      // TEST REVERSE MUTUAL EXCLUSION: Turn ON SMS
      await tester.ensureVisible(smsNotificationsToggle);
      await tester.tap(smsNotificationsToggle);
      await tester.pumpAndSettle();

      // Verify Biometric automatically turned OFF
      // We need to wait a moment for the state change to propagate
      await tester.pump(const Duration(milliseconds: 100));

      // Session Timeout should be disabled again (because SMS is ON)
      sessionSwitch = tester.widget(sessionTimeoutToggle);
      expect(sessionSwitch.enabled, isFalse, reason: 'Session Timeout should be disabled when SMS is ON');

      // Device Tracking should be enabled again (because Biometric is OFF)
      deviceSwitch = tester.widget(deviceTrackingToggle);
      expect(deviceSwitch.enabled, isTrue, reason: 'Device Tracking should be enabled when Biometric is OFF');

      print('✅ Complex toggle dependencies and mutual exclusion working correctly');
    });

    testWidgets('Test form validation with required fields', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonFile = File('integration_test/json_files/security_settings_form.json');
      final jsonContent = await jsonFile.readAsString();
      
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      // Scroll to make Submit button visible
      await tester.ensureVisible(find.text('Submit'));
      await tester.pumpAndSettle();
      
      // Try to submit form without filling required fields
      final submitButton = find.text('Submit');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify validation error is shown
      expect(find.text('Please fix form errors'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      // Fill required fields
      final usernameField = find.byKey(const ValueKey('username'));
      final emailField = find.byKey(const ValueKey('email'));

      // Scroll to and fill username
      await tester.ensureVisible(usernameField);
      await tester.pumpAndSettle();
      await tester.tap(usernameField);
      await tester.pumpAndSettle();
      await tester.enterText(usernameField, 'testuser');
      await tester.pumpAndSettle();
      
      // Scroll to and fill email
      await tester.ensureVisible(emailField);
      await tester.pumpAndSettle();
      await tester.tap(emailField);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Submit again (scroll first to ensure button is visible)
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Check for any error messages first
      final errorMessage = find.text('Please fix form errors');
      final successMessage = find.text('Form submitted successfully!');
      
      if (errorMessage.evaluate().isNotEmpty) {
        print('❌ Form still has validation errors after filling required fields');
        // Let's see what's on screen
        final allText = find.byType(Text);
        for (final element in allText.evaluate()) {
          final textWidget = element.widget as Text;
          print('Found text: "${textWidget.data}"');
        }
      }

      // Verify success message
      expect(successMessage, findsOneWidget);

      print('✅ Form validation working correctly');
    });
    
    testWidgets('Test form reset functionality', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonFile = File('integration_test/json_files/security_settings_form.json');
      final jsonContent = await jsonFile.readAsString();
      
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      // Fill form fields
      await tester.enterText(find.byKey(const ValueKey('username')), 'testuser');
      await tester.enterText(find.byKey(const ValueKey('email')), 'test@example.com');
      
      // Toggle some switches
      await tester.tap(find.byKey(const ValueKey('sessionTimeout')));
      await tester.pumpAndSettle();

      // Verify fields have values
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);

      // Scroll to make Reset button visible
      await tester.ensureVisible(find.text('Reset'));
      await tester.pumpAndSettle();
      
      // Reset the form
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Verify fields are reset by checking the text controllers are empty
      final usernameAfterReset = find.byKey(const ValueKey('username'));
      final emailAfterReset = find.byKey(const ValueKey('email'));
      
      FormBuilderTextField usernameWidget = tester.widget(usernameAfterReset);
      FormBuilderTextField emailWidget = tester.widget(emailAfterReset);
      
      // Check that the controller values are reset
      expect(usernameWidget.controller?.text ?? '', equals(''), reason: 'Username field should be empty after reset');
      expect(emailWidget.controller?.text ?? '', equals(''), reason: 'Email field should be empty after reset');

      print('✅ Form reset working correctly');
    });
  });
}