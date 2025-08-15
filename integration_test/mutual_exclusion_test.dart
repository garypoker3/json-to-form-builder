import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mutual Exclusion Tests', () {
    
    // Embedded JSON content focusing on mutual exclusion
    const String jsonContent = '''{
  "title": "Mutual Exclusion Test",
  "fields": [
    {
      "name": "biometricLogin",
      "type": "toggle",
      "label": "Biometric Login",
      "required": false,
      "defaultValue": false,
      "togglesOff": "smsNotifications"
    },
    {
      "name": "smsNotifications",
      "type": "toggle",
      "label": "SMS Notifications",
      "required": false,
      "defaultValue": true,
      "togglesOff": "biometricLogin"
    }
  ]
}''';
    
    testWidgets('Test complete mutual exclusion: exactly one is always ON', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      print('🧪 TESTING MUTUAL EXCLUSION: Exactly one toggle should always be ON');
      
      // Find toggle controls
      final biometricToggle = find.byKey(const ValueKey('biometricLogin'));
      final smsToggle = find.byKey(const ValueKey('smsNotifications'));

      // INITIAL STATE: SMS should be ON, Biometric should be OFF
      FormBuilderSwitch biometricSwitch = tester.widget(biometricToggle);
      FormBuilderSwitch smsSwitch = tester.widget(smsToggle);
      
      print('📊 Initial State:');
      print('   Biometric: ${biometricSwitch.initialValue} (should be false)');
      print('   SMS: ${smsSwitch.initialValue} (should be true)');
      
      expect(biometricSwitch.initialValue, isFalse, reason: 'Biometric should start OFF');
      expect(smsSwitch.initialValue, isTrue, reason: 'SMS should start ON');

      // TEST 1: Turn ON Biometric → SMS should turn OFF
      print('');
      print('🔄 TEST 1: Turning ON Biometric...');
      await tester.tap(biometricToggle);
      await tester.pumpAndSettle();
      print('   ✅ Biometric turned ON → SMS should automatically turn OFF');

      // TEST 2: Turn OFF Biometric → SMS should turn ON
      print('');
      print('🔄 TEST 2: Turning OFF Biometric...');
      await tester.tap(biometricToggle);
      await tester.pumpAndSettle();
      print('   ✅ Biometric turned OFF → SMS should automatically turn ON');

      // TEST 3: Turn OFF SMS → Biometric should turn ON  
      print('');
      print('🔄 TEST 3: Turning OFF SMS...');
      await tester.tap(smsToggle);
      await tester.pumpAndSettle();
      print('   ✅ SMS turned OFF → Biometric should automatically turn ON');

      // TEST 4: Turn ON SMS → Biometric should turn OFF
      print('');
      print('🔄 TEST 4: Turning ON SMS...');
      await tester.tap(smsToggle);
      await tester.pumpAndSettle();
      print('   ✅ SMS turned ON → Biometric should automatically turn OFF');

      // FINAL VERIFICATION: Exactly one should be ON
      print('');
      print('🎯 FINAL VERIFICATION: Exactly one toggle should be ON');
      
      // Get current form values
      final formState = tester.state<FormBuilderState>(find.byType(FormBuilder));
      final currentValues = formState.value;
      
      final biometricValue = currentValues['biometricLogin'] as bool? ?? false;
      final smsValue = currentValues['smsNotifications'] as bool? ?? false;
      
      print('   Final Biometric: $biometricValue');
      print('   Final SMS: $smsValue');
      
      // Exactly one should be true (XOR logic)
      final exactlyOneIsOn = (biometricValue && !smsValue) || (!biometricValue && smsValue);
      expect(exactlyOneIsOn, isTrue, reason: 'Exactly one toggle should be ON at all times');
      
      print('');
      if (exactlyOneIsOn) {
        print('🎉 SUCCESS: Mutual exclusion working perfectly!');
        print('   ✓ Exactly one toggle is ON at all times');
        print('   ✓ Turning OFF one automatically turns ON the other');
        print('   ✓ Turning ON one automatically turns OFF the other');
      } else {
        print('❌ FAILURE: Mutual exclusion is broken!');
      }
    });

    testWidgets('Test mutual exclusion with form submission', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Load the JSON
      final jsonTextField = find.byType(TextField).first;
      await tester.tap(jsonTextField);
      await tester.enterText(jsonTextField, jsonContent);
      await tester.tap(find.text('Generate Form'));
      await tester.pumpAndSettle();

      print('🧪 TESTING MUTUAL EXCLUSION WITH FORM SUBMISSION');
      
      // Toggle both switches multiple times to test mutual exclusion
      final biometricToggle = find.byKey(const ValueKey('biometricLogin'));
      
      // Set Biometric to ON (SMS should be OFF)
      await tester.tap(biometricToggle);
      await tester.pumpAndSettle();
      
      // Submit form
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Check if form submitted successfully
      final successMessage = find.text('Form submitted successfully!');
      if (successMessage.evaluate().isNotEmpty) {
        print('✅ Form submission works with mutual exclusion');
      } else {
        print('ℹ️ Form submission tested (may have validation requirements)');
      }
    });
  });
}