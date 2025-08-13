import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_to_form/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Resident Toggle Tests', () {
    testWidgets('Test 2: Resident toggle off disables Subscribe checkbox', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the resident toggle and subscribe checkbox
      final residentToggle = find.byKey(const ValueKey('resident'));
      final subscribeCheckbox = find.byKey(const ValueKey('subscribe'));

      // Verify initial state: resident toggle should be ON (true), subscribe should be enabled
      Switch residentSwitch = tester.widget(residentToggle) as Switch;
      expect(residentSwitch.value, isTrue, reason: 'Resident toggle should be ON by default');

      // Verify subscribe checkbox is initially enabled
      Checkbox subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.onChanged, isNotNull, reason: 'Subscribe checkbox should be enabled initially');

      // Tap the resident toggle to turn it OFF
      await tester.tap(residentToggle);
      await tester.pumpAndSettle();

      // Verify resident toggle is now OFF
      residentSwitch = tester.widget(residentToggle) as Switch;
      expect(residentSwitch.value, isFalse, reason: 'Resident toggle should be OFF after tap');

      // Verify subscribe checkbox is now disabled
      subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.onChanged, isNull, reason: 'Subscribe checkbox should be disabled when resident is OFF');

      // Tap resident toggle again to turn it back ON
      await tester.tap(residentToggle);
      await tester.pumpAndSettle();

      // Verify subscribe checkbox is enabled again
      subscribeCheckboxWidget = tester.widget(subscribeCheckbox);
      expect(subscribeCheckboxWidget.onChanged, isNotNull, reason: 'Subscribe checkbox should be enabled when resident is ON');

      print('Test 2 passed: Resident toggle properly controls subscribe checkbox accessibility');
    });
  });
}