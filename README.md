# JSON to Form Builder

A Flutter application that dynamically generates forms from JSON configurations with real-time validation, conditional field dependencies, and comprehensive testing.

## 🚀 Features

- **Dynamic Form Generation**: Creates forms automatically from JSON schema
- **Split Panel Interface**: Horizontal resizable panels for JSON input and form preview
- **JSON Formatting**: Built-in JSON formatter with syntax validation
- **Field Dependencies**: Conditional field enabling/disabling based on other field values
- **Complex Toggle Dependencies**: Mutual exclusion and chain reactions between toggle fields
- **Form Validation**: Real-time validation with custom rules and error handling
- **Multiple Field Types**: Support for text, email, number, dropdown, checkbox, and toggle fields
- **Grouped Fields**: Organize fields into labeled groups with bordered containers
- **Form Submission & Reset**: Complete form lifecycle management
- **Comprehensive Testing**: Integration tests covering all major functionality

## 🏗️ Architecture & Packages

### Core Dependencies

- **`flutter_form_builder: ^10.1.0`**: Advanced form building with validation
- **`form_builder_validators: ^11.0.0`**: Pre-built validation rules
- **`split_view: ^3.2.1`**: Resizable split panel interface
- **`json_annotation: ^4.9.0`**: JSON serialization support

### Development Dependencies

- **`integration_test`**: End-to-end testing framework
- **`flutter_test`**: Widget and unit testing
- **`flutter_lints: ^5.0.0`**: Code quality and style enforcement

## 🎯 Supported Field Types

| Type | Description | Validation | Advanced Features |
|------|-------------|------------|------------------|
| `text` | Basic text input | Required, length validation | Default values, grouping |
| `email` | Email input with validation | Email format validation | Default values, grouping |
| `number` | Numeric input | Min/max value validation | Grouping |
| `dropdown` | Select from predefined options | Required selection | Grouping |
| `checkbox` | Boolean checkbox | Required checking | Conditional dependencies |
| `toggle` | Switch toggle | Conditional dependencies | Mutual exclusion, chain reactions |

## 📋 JSON Schema Examples

### Basic Form Example
```json
{
  "title": "User Registration Form",
  "fields": [
    {
      "name": "firstName",
      "type": "text",
      "label": "First Name",
      "required": true,
      "placeholder": "Enter your first name"
    },
    {
      "name": "resident",
      "type": "toggle",
      "label": "Resident",
      "required": false,
      "defaultValue": true
    }
  ]
}
```

### Advanced Form with Groups and Complex Dependencies
```json
{
  "title": "Security Settings Configuration",
  "fields": [
    {
      "name": "username",
      "type": "text",
      "label": "Username",
      "required": true,
      "group": "Account Information"
    },
    {
      "name": "biometricLogin",
      "type": "toggle",
      "label": "Biometric Login",
      "defaultValue": false,
      "group": "Security Features",
      "togglesOff": "smsNotifications"
    },
    {
      "name": "smsNotifications",
      "type": "toggle",
      "label": "SMS Notifications",
      "defaultValue": true,
      "group": "Security Features",
      "togglesOff": "biometricLogin"
    },
    {
      "name": "notes",
      "type": "text",
      "label": "Security Notes",
      "defaultValue": "Default security notes...",
      "group": "Additional Notes"
    }
  ]
}
```

## 🧪 Integration Tests

The application includes comprehensive integration tests covering:

### Test Suite Overview

#### Core Test Suite (app_test.dart)
| Test | Description | Coverage |
|------|-------------|----------|
| **Test 1: Form Validation** | Only First Name set → Submit shows validation error | Required field validation |
| **Test 2: Conditional Fields** | Resident toggle OFF → Subscribe checkbox disabled | Field dependencies |
| **Test 3: Reset Functionality** | All fields filled → Reset restores defaults | Form state management |
| **Bonus Test: Complete Flow** | Full form submission with success validation | End-to-end workflow |

#### Advanced Test Suite (json_form_test.dart)
| Test | Description | Coverage |
|------|-------------|----------|
| **JSON Form Creation** | Load JSON from file → Verify 8 fields in 3 groups | Grouped form generation |
| **Complex Dependencies** | Test toggle mutual exclusion and chain reactions | Advanced toggle logic |
| **Form Validation** | Required fields validation with grouped fields | Enhanced validation |
| **Form Reset** | Reset grouped form to default values | Advanced state management |

#### Toggle Dependencies Demo (toggle_demo_test.dart)
| Test | Description | Coverage |
|------|-------------|----------|
| **Mutual Exclusion Demo** | Biometric ↔ SMS toggle interaction | Complex toggle dependencies |
| **Chain Reaction Demo** | Session timeout and device tracking rules | Conditional field disabling |
| **Form Submission Demo** | End-to-end with complex toggle states | Integration workflow |

### Test Implementation Details

#### Test 1: Form Validation
- Fills only the First Name field
- Clicks Submit button
- Verifies validation error snackbar appears
- Confirms "Please fix form errors" message

#### Test 2: Resident Toggle Functionality
- Verifies initial state: Resident ON, Subscribe enabled
- Toggles Resident OFF → Subscribe becomes disabled
- Toggles Resident ON → Subscribe re-enabled
- Tests conditional field dependency logic

#### Test 3: Reset Button
- Sets Resident toggle to OFF
- Fills all form fields with test data
- Clicks Reset button
- Verifies all fields cleared and defaults restored

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1+)
- Dart SDK
- VS Code with Dart/Flutter extensions (recommended)

### Installation

1. **Clone and setup:**
   ```bash
   git clone <repository-url>
   cd json_to_form
   flutter pub get
   ```

2. **Run the application:**
   ```bash
   flutter run -d linux
   # or for other platforms:
   flutter run -d chrome
   flutter run -d windows
   ```

## 🧪 Running Tests

### Option 1: VS Code (Recommended)

#### Prerequisites
- Install the **Dart extension** for VS Code
- Install the **Flutter extension** for VS Code

#### Running Tests via VS Code Debugger

1. **Open VS Code** in the project directory
2. **Press F5** or go to **Run and Debug** panel (Ctrl+Shift+D)
3. **Select test configuration:**
   - `Run All Integration Tests (Master File)` - **NEW: All tests in one run**
   - `Run Integration Tests (All)` - Run original core tests
   - `Run Toggle Dependencies Demo` - **NEW: Complex toggle dependencies demo**
   - `Run JSON Form Test` - **NEW: Advanced grouped form tests**
   - `Run Form Validation Test` - Individual core test
   - `Run Resident Toggle Test` - Individual core test
   - `Run Reset Button Test` - Individual core test

#### Running Tests via VS Code Tasks

1. **Press Ctrl+Shift+P** to open Command Palette
2. **Type "Tasks: Run Task"**
3. **Select desired test:**
   - `Run All Integration Tests`
   - `Run Form Validation Test`
   - `Run Resident Toggle Test`
   - `Run Reset Button Test`

#### Setting Breakpoints
- Open any test file in `integration_test/`
- Click in the gutter to set breakpoints
- Run tests in debug mode to step through code

### Option 2: Terminal Commands

#### Run All Tests

**⚠️ Important:** Running `flutter test integration_test/ -d linux` will fail after the first test due to debug connection issues. Use these solutions instead:

**Option A: Master Test File (Recommended)**
```bash
flutter test integration_test/all_tests.dart -d linux
```

**Option B: Shell Script (Alternative)**
```bash
./run_all_tests.sh
```

**Option C: Individual Tests (Most Reliable)**
```bash
flutter test integration_test/app_test.dart -d linux
```

#### Run Individual Tests
```bash
# Core tests
flutter test integration_test/form_validation_test.dart -d linux
flutter test integration_test/resident_toggle_test.dart -d linux
flutter test integration_test/reset_button_test.dart -d linux

# NEW: Advanced tests
flutter test integration_test/toggle_demo_test.dart -d linux          # Complex toggle dependencies demo
flutter test integration_test/json_form_test.dart -d linux            # Advanced grouped form tests
```

#### Run Tests with Verbose Output
```bash
flutter test integration_test/app_test.dart -d linux --verbose
```

#### Run Tests for Different Platforms
```bash
# Chrome (web)
flutter test integration_test/app_test.dart -d chrome

# Windows
flutter test integration_test/app_test.dart -d windows
```

### Test Output Example

```
✓ Built build/linux/x64/debug/bundle/json_to_form
00:15 +0: JSON to Form Builder Integration Tests Test 1: Only First Name set shows validation error on Submit
Form generated successfully with 7 fields
Form validation failed
✅ Test 1 passed: Validation error shown when only First Name is set
00:17 +1: JSON to Form Builder Integration Tests Test 2: Resident toggle off disables Subscribe checkbox
✅ Test 2 passed: Resident toggle properly controls subscribe checkbox accessibility
00:18 +2: JSON to Form Builder Integration Tests Test 3: Reset button restores all fields to default values
✅ Test 3 passed: Reset button properly restores all fields to default values
00:23 +4: All tests passed!
```

## 🏗️ Project Structure

```
lib/
  ├── main.dart                 # Main app entry point with grouped fields support
integration_test/
  ├── all_tests.dart           # NEW: Master file to run all tests together
  ├── app_test.dart            # Original comprehensive test suite
  ├── json_form_test.dart      # NEW: Advanced grouped form tests
  ├── toggle_demo_test.dart    # NEW: Complex toggle dependencies demo
  ├── json_files/              # NEW: Test JSON configurations
  │   └── security_settings_form.json # Advanced form with groups & dependencies
  ├── form_validation_test.dart # Individual validation test
  ├── resident_toggle_test.dart # Individual toggle test  
  └── reset_button_test.dart   # Individual reset test
├── run_all_tests.sh         # NEW: Shell script to run all tests sequentially
├── run_tests_simple.sh      # NEW: Simple test runner script
.vscode/
  ├── launch.json             # VS Code debugger config (updated with new tests)
  └── tasks.json              # VS Code task runner config
```

## 🎯 Key Implementation Highlights

### Grouped Field Organization
- Fields can be organized into visual groups using the `group` property
- Groups are rendered as bordered containers with labeled headers
- Supports mixed grouped and ungrouped fields in the same form

### Complex Toggle Dependencies
- **Mutual Exclusion**: Use `togglesOff` to automatically turn off another toggle
- **Conditional Disabling**: Use `dependsOn` and `dependsValue` for conditional field states
- **Chain Reactions**: Multiple toggles can affect each other in complex ways
- Real-time UI updates when dependency conditions change

### Form Validation Strategy
- Client-side validation using FormBuilder validators
- Custom validation rules for specific business logic
- Comprehensive error handling and user feedback
- Support for default values in text and toggle fields

### Testing Approach  
- Widget testing for UI component verification
- Integration testing for end-to-end user workflows
- Complex dependency testing with realistic scenarios
- Debugger-friendly test structure for development

## 🔧 Technical Architecture Deep Dive

### Form Builder Core Logic

The app uses a **reactive architecture** where:

1. **JSON Parser** (`_generateForm()` in main.dart:95)
   - Validates JSON structure requires `fields` array
   - Handles parsing errors with user-friendly messages
   - Triggers UI rebuild on successful parsing

2. **Dynamic Field Generation** (`_buildFormField()` in main.dart:192)
   - Switch-case pattern for field type resolution
   - ValueKey assignment for testing widget identification
   - Conditional rendering based on `dependsOn`/`dependsValue` logic

3. **Dependency Management**
   - Fields check dependency state in real-time (main.dart:204-207)
   - FormBuilder state triggers rebuilds on toggle changes
   - `setState()` called in toggle `onChanged` to refresh dependent fields

### Key Files and Responsibilities

| File | Purpose | Key Functions |
|------|---------|---------------|
| `lib/main.dart` | Main app logic | `_generateForm()`, `_buildFormField()`, `_buildFormPanel()` |
| `integration_test/app_test.dart` | Comprehensive test suite | All 4 tests in single file for debugging |
| `.vscode/launch.json` | Debug configurations | Individual test runners + all tests |
| `.vscode/tasks.json` | VS Code tasks | Terminal-based test execution |

### State Management Pattern

```dart
// Form state flows:
JSON Input → _generateForm() → setState() → Widget Rebuild
Toggle Change → onChanged() → setState() → Dependent Field Update
Form Submit → FormBuilder.saveAndValidate() → Success/Error Feedback
```

## 📝 Development Session Notes

### Initial Development (Session 1)
- **Goal**: Create dynamic form builder from JSON with testing
- **Challenges Solved**:
  - Split view package API compatibility (switched from `multi_split_view` to `split_view`)
  - Widget type casting in tests (FormBuilderSwitch vs Switch)
  - Form reset functionality with default value restoration
- **Key Decisions**:
  - Used flutter_form_builder for robust validation
  - Implemented conditional dependencies via custom logic
  - Age validation set to 20-85 years per requirements
  - Resident toggle defaults to ON, controls newsletter subscription

### Testing Implementation Strategy
- **Integration over Unit**: Focus on end-to-end user workflows
- **Widget Key Strategy**: ValueKey(fieldName) for reliable widget finding
- **Test Independence**: Each test starts fresh app instance
- **Visual Verification**: Tests check both widget state and user-visible feedback

## 🚀 Future Enhancement Roadmap

### High Priority
- [ ] **Field Type Extensions**: Add date picker, file upload, radio buttons
- [ ] **JSON Schema Validation**: Implement JSON schema validation for form definitions
- [ ] **Form Themes**: Support for custom styling via JSON configuration
- [ ] **Data Persistence**: Save/load form data locally or to cloud

### Medium Priority  
- [ ] **Drag & Drop Builder**: Visual form builder interface
- [ ] **Conditional Branching**: Advanced logic with AND/OR conditions
- [ ] **Field Groups**: Organize fields into collapsible sections
- [ ] **Multi-page Forms**: Step-by-step form wizard functionality

### Low Priority
- [ ] **Form Analytics**: Track user interaction patterns
- [ ] **Export Options**: PDF, CSV, JSON data export
- [ ] **Internationalization**: Multi-language support
- [ ] **Accessibility**: Screen reader and keyboard navigation enhancements

## 🐛 Known Issues & Limitations

### Current Limitations
1. **Single Dependency**: Fields can only depend on one other field (no complex logic)
2. **Basic Field Types**: Limited to text, email, number, dropdown, checkbox, toggle
3. **No Nested Objects**: JSON schema doesn't support nested form structures
4. **Static Validation**: Validation rules are predefined, not configurable via JSON

### Troubleshooting Common Issues

#### Tests Not Running in VS Code
```bash
# Ensure Dart/Flutter extensions are installed
# Try running from terminal first:
flutter test integration_test/app_test.dart -d linux
```

#### Split View Not Resizing
```dart
// Issue: Panels not responsive
// Solution: Ensure parent widget has defined constraints
// Check SplitView is wrapped in Expanded/Flexible widget
```

#### Form Validation Errors
```bash
# Common cause: Missing required fields
# Check JSON schema includes required: true for mandatory fields
# Verify field names match between JSON and form submission
```

## 💡 Development Tips for Future Sessions

### Quick Start Checklist
1. **Environment**: Ensure Flutter 3.8.1+ with Linux/Chrome support
2. **Dependencies**: Run `flutter pub get` after pulling changes
3. **Testing**: Start with `flutter test integration_test/app_test.dart -d linux`
4. **Development**: Use `flutter run -d linux` for live development

### Code Organization Philosophy
- **Single File App**: All logic in `main.dart` for simplicity (suitable for demo/prototype)
- **Test Separation**: Individual test files + comprehensive suite for flexibility
- **Configuration First**: VS Code configs provided for immediate productivity

### JSON Schema Extension Pattern
```json
// To add new field types, follow this pattern:
{
  "name": "newField",
  "type": "newType",
  "label": "Display Label",
  "required": false,
  "customProperty": "customValue",
  // Add conditional dependency:
  "dependsOn": "otherFieldName",
  "dependsValue": expectedValue
}
```

### Testing New Features
1. Add field type to switch statement in `_buildFormField()`
2. Create individual test file in `integration_test/`
3. Add test to comprehensive suite in `app_test.dart`
4. Update VS Code launch/tasks configurations
5. Document in README field types table

## 🔍 Quick Reference

### Essential Commands
```bash
# Development
flutter run -d linux
flutter pub get

# Testing (choose one)
flutter test integration_test/app_test.dart -d linux          # All tests
flutter test integration_test/form_validation_test.dart -d linux  # Individual test

# Git workflow
git add . && git commit -m "Description" && git push
```

### Key Widget Identifiers
```dart
// For testing - these ValueKeys are set:
find.byKey(ValueKey('firstName'))   // First name field
find.byKey(ValueKey('resident'))    // Resident toggle
find.byKey(ValueKey('subscribe'))   // Subscribe checkbox
find.text('Submit')                 // Submit button
find.text('Reset')                  // Reset button
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Run tests (`flutter test integration_test/app_test.dart -d linux`)
4. Commit changes (`git commit -m 'Add AmazingFeature'`)
5. Push branch (`git push origin feature/AmazingFeature`)
6. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.