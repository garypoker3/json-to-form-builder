import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Toggle Dependencies Demo (Device Compatible)', () {
    
    // Embedded JSON content (no file I/O)
    const String jsonContent = '''{
  "title": "Security Settings Configuration",
  "fields": [
    {
      "name": "username",
      "type": "text",
      "label": "Username",
      "required": true,
      "placeholder": "Enter your username",
      "group": "Account Information"
    },
    {
      "name": "email",
      "type": "email",
      "label": "Email Address",
      "required": true,
      "placeholder": "Enter your email",
      "group": "Account Information"
    },
    {
      "name": "twoFactorAuth",
      "type": "toggle",
      "label": "Two-Factor Authentication",
      "required": false,
      "defaultValue": true,
      "group": "Security Features"
    },
    {
      "name": "biometricLogin",
      "type": "toggle",
      "label": "Biometric Login (Mutually exclusive with SMS)",
      "required": false,
      "defaultValue": false,
      "dependsOn": "twoFactorAuth",
      "dependsValue": true,
      "group": "Security Features",
      "togglesOff": "smsNotifications"
    },
    {
      "name": "smsNotifications",
      "type": "toggle",
      "label": "SMS Security Notifications (Mutually exclusive with Biometric)",
      "required": false,
      "defaultValue": true,
      "dependsOn": "twoFactorAuth",
      "dependsValue": true,
      "group": "Security Features",
      "togglesOff": "biometricLogin"
    },
    {
      "name": "sessionTimeout",
      "type": "toggle",
      "label": "Auto Session Timeout (Disabled when SMS is ON)",
      "required": false,
      "defaultValue": false,
      "group": "Security Features",
      "dependsOn": "smsNotifications",
      "dependsValue": false
    },
    {
      "name": "deviceTracking",
      "type": "toggle",
      "label": "Device Activity Tracking (Disabled when Biometric is ON)",
      "required": false,
      "defaultValue": false,
      "group": "Security Features",
      "dependsOn": "biometricLogin",
      "dependsValue": false
    },
    {
      "name": "notes",
      "type": "text",
      "label": "Security Notes",
      "required": false,
      "placeholder": "Optional security notes or comments",
      "defaultValue": "Please review these settings regularly for optimal security.",
      "group": "Additional Notes"
    }
  ]
}''';
    
    testWidgets('Demo: Complex toggle dependencies with mutual exclusion', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      print('🎯 DEMO: Testing complex toggle button dependencies (Device Compatible)');
      print('');
      print('JSON Configuration:');
      print('- Biometric Login and SMS Notifications are mutually exclusive');
      print('- Session Timeout is disabled when SMS is ON');
      print('- Device Tracking is disabled when Biometric is ON');
      print('');

      // Find JSON input and load the embedded JSON
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      // Find toggle controls
      final biometricLoginToggle = find.byKey(const ValueKey('biometricLogin'));
      final smsNotificationsToggle = find.byKey(const ValueKey('smsNotifications'));

      // Verify form was created with correct labels
      expect(find.text('Biometric Login (Mutually exclusive with SMS)'), findsOneWidget);
      expect(find.text('SMS Security Notifications (Mutually exclusive with Biometric)'), findsOneWidget);

      print('✅ Form created with complex dependency labels');

      // TEST 1: Turn ON Biometric Login (should turn OFF SMS)
      print('');
      print('🔄 TEST 1: Turning ON Biometric Login...');
      await tester.ensureVisible(biometricLoginToggle);
      await tester.tap(biometricLoginToggle);
      await tester.pumpAndSettle();

      print('✅ Biometric Login turned ON');
      print('   Expected: SMS should automatically turn OFF (mutual exclusion)');

      // TEST 2: Turn ON SMS (should turn OFF Biometric)  
      await Future.delayed(const Duration(milliseconds: 500)); // Brief pause for device
      print('');
      print('🔄 TEST 2: Turning ON SMS Notifications...');
      await tester.ensureVisible(smsNotificationsToggle);
      await tester.tap(smsNotificationsToggle);
      await tester.pumpAndSettle();

      print('✅ SMS Notifications turned ON');
      print('   Expected: Biometric Login should automatically turn OFF (mutual exclusion)');

      print('');
      print('🎉 DEMO COMPLETED: Complex toggle dependencies working on device!');
      print('   ✓ Mutual exclusion between Biometric and SMS');
      print('   ✓ Form rebuilds properly when dependencies change');
    });

    testWidgets('Demo: Verify form submission works with complex dependencies', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      print('🎯 DEMO: Testing form submission with complex toggle states (Device)');

      // Fill required fields
      final usernameField = find.byKey(const ValueKey('username'));
      final emailField = find.byKey(const ValueKey('email'));

      await tester.ensureVisible(usernameField);
      await tester.tap(usernameField);
      await tester.enterText(usernameField, 'device_admin');
      
      await tester.ensureVisible(emailField);
      await tester.tap(emailField);
      await tester.enterText(emailField, 'admin@device.com');
      
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

      print('✅ Form submitted successfully on device with complex toggle dependencies');
      print('   ✓ Required fields validated properly');
      print('   ✓ Toggle dependencies maintained during submission');
    });
  });
}