import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import all test suites
import 'app_test.dart' as app_tests;
import 'form_validation_test.dart' as form_validation_tests;
import 'resident_toggle_test.dart' as resident_toggle_tests;
import 'reset_button_test.dart' as reset_button_tests;
import 'json_form_test.dart' as json_form_tests;
import 'toggle_demo_test.dart' as toggle_demo_tests;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('🚀 ALL INTEGRATION TESTS', () {
    group('📋 Core Test Suite', () {
      app_tests.main();
    });
    
    group('📝 Form Validation Tests', () {
      form_validation_tests.main();
    });
    
    group('🔄 Resident Toggle Tests', () {
      resident_toggle_tests.main();
    });
    
    group('↺ Reset Button Tests', () {
      reset_button_tests.main();
    });
    
    group('📊 Advanced JSON Form Tests', () {
      json_form_tests.main();
    });
    
    group('🎮 Toggle Dependencies Demo', () {
      toggle_demo_tests.main();
    });
  });
}