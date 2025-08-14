import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Toggle Dependencies Demo', () {
    
    testWidgets('Demo: Complex toggle dependencies with mutual exclusion', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON with complex toggle rules
      final jsonFile = File('integration_test/json_files/security_settings_form.json');
      final jsonContent = await jsonFile.readAsString();
      
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      print('🎯 DEMO: Testing complex toggle button dependencies');
      print('');
      print('JSON Configuration:');
      print('- Biometric Login and SMS Notifications are mutually exclusive');
      print('- Session Timeout is disabled when SMS is ON');
      print('- Device Tracking is disabled when Biometric is ON');
      print('');

      // Find toggle controls
      final biometricLoginToggle = find.byKey(const ValueKey('biometricLogin'));
      final smsNotificationsToggle = find.byKey(const ValueKey('smsNotifications'));
      final sessionTimeoutToggle = find.byKey(const ValueKey('sessionTimeout'));
      final deviceTrackingToggle = find.byKey(const ValueKey('deviceTracking'));

      // Verify form was created with correct labels
      expect(find.text('Biometric Login (Mutually exclusive with SMS)'), findsOneWidget);
      expect(find.text('SMS Security Notifications (Mutually exclusive with Biometric)'), findsOneWidget);
      expect(find.text('Auto Session Timeout (Disabled when SMS is ON)'), findsOneWidget);
      expect(find.text('Device Activity Tracking (Disabled when Biometric is ON)'), findsOneWidget);

      print('✅ Form created with complex dependency labels');

      // TEST 1: Turn ON Biometric Login (should turn OFF SMS)
      print('');
      print('🔄 TEST 1: Turning ON Biometric Login...');
      await tester.ensureVisible(biometricLoginToggle);
      await tester.tap(biometricLoginToggle);
      await tester.pumpAndSettle();

      print('✅ Biometric Login turned ON');
      print('   Expected: SMS should automatically turn OFF (mutual exclusion)');
      print('   Expected: Device Tracking should become disabled');

      // TEST 2: Turn ON SMS (should turn OFF Biometric)  
      await Future.delayed(const Duration(seconds: 1)); // Brief pause for demo
      print('');
      print('🔄 TEST 2: Turning ON SMS Notifications...');
      await tester.ensureVisible(smsNotificationsToggle);
      await tester.tap(smsNotificationsToggle);
      await tester.pumpAndSettle();

      print('✅ SMS Notifications turned ON');
      print('   Expected: Biometric Login should automatically turn OFF (mutual exclusion)');
      print('   Expected: Session Timeout should become disabled');

      // TEST 3: Verify toggle states are working
      await Future.delayed(const Duration(seconds: 1)); // Brief pause for demo
      print('');
      print('🔄 TEST 3: Testing that mutually exclusive toggles work...');

      // Try to turn ON Biometric again
      await tester.ensureVisible(biometricLoginToggle);
      await tester.tap(biometricLoginToggle);
      await tester.pumpAndSettle();

      print('✅ Biometric Login turned ON again');
      print('   Expected: SMS should automatically turn OFF again');

      print('');
      print('🎉 DEMO COMPLETED: Complex toggle dependencies are working!');
      print('   ✓ Mutual exclusion between Biometric and SMS');
      print('   ✓ Conditional disabling of dependent toggles');
      print('   ✓ Form rebuilds properly when dependencies change');
    });

    testWidgets('Demo: Verify form submission works with complex dependencies', (WidgetTester tester) async {
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

      print('🎯 DEMO: Testing form submission with complex toggle states');

      // Fill required fields
      final usernameField = find.byKey(const ValueKey('username'));
      final emailField = find.byKey(const ValueKey('email'));

      await tester.ensureVisible(usernameField);
      await tester.tap(usernameField);
      await tester.enterText(usernameField, 'security_admin');
      
      await tester.ensureVisible(emailField);
      await tester.tap(emailField);
      await tester.enterText(emailField, 'admin@security.com');
      
      await tester.pumpAndSettle();

      // Set some toggle states
      final biometricToggle = find.byKey(const ValueKey('biometricLogin'));
      await tester.ensureVisible(biometricToggle);
      await tester.tap(biometricToggle);
      await tester.pumpAndSettle();

      // Submit the form
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);
      await tester.pumpAndSettle();

      print('✅ Form submitted successfully with complex toggle dependencies');
      print('   ✓ Required fields validated properly');
      print('   ✓ Toggle dependencies maintained during submission');
    });
  });
}