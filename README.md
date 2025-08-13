# JSON to Form Builder

A Flutter application that dynamically generates forms from JSON configurations with real-time validation, conditional field dependencies, and comprehensive testing.

## 🚀 Features

- **Dynamic Form Generation**: Creates forms automatically from JSON schema
- **Split Panel Interface**: Horizontal resizable panels for JSON input and form preview
- **JSON Formatting**: Built-in JSON formatter with syntax validation
- **Field Dependencies**: Conditional field enabling/disabling based on other field values
- **Form Validation**: Real-time validation with custom rules and error handling
- **Multiple Field Types**: Support for text, email, number, dropdown, checkbox, and toggle fields
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

| Type | Description | Validation |
|------|-------------|------------|
| `text` | Basic text input | Required, length validation |
| `email` | Email input with validation | Email format validation |
| `number` | Numeric input | Min/max value validation |
| `dropdown` | Select from predefined options | Required selection |
| `checkbox` | Boolean checkbox | Required checking |
| `toggle` | Switch toggle | Conditional dependencies |

## 📋 JSON Schema Example

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
      "name": "age",
      "type": "number",
      "label": "Age",
      "required": false,
      "min": 20,
      "max": 85
    },
    {
      "name": "subscribe",
      "type": "checkbox",
      "label": "Subscribe to newsletter",
      "required": false,
      "dependsOn": "resident",
      "dependsValue": true
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

## 🧪 Integration Tests

The application includes comprehensive integration tests covering:

### Test Suite Overview

| Test | Description | Coverage |
|------|-------------|----------|
| **Test 1: Form Validation** | Only First Name set → Submit shows validation error | Required field validation |
| **Test 2: Conditional Fields** | Resident toggle OFF → Subscribe checkbox disabled | Field dependencies |
| **Test 3: Reset Functionality** | All fields filled → Reset restores defaults | Form state management |
| **Bonus Test: Complete Flow** | Full form submission with success validation | End-to-end workflow |

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
   - `Run Integration Tests (All)` - Run all tests
   - `Run Form Validation Test` - Test 1 only
   - `Run Resident Toggle Test` - Test 2 only  
   - `Run Reset Button Test` - Test 3 only

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
```bash
flutter test integration_test/app_test.dart -d linux
```

#### Run Individual Tests
```bash
# Form validation test
flutter test integration_test/form_validation_test.dart -d linux

# Resident toggle test  
flutter test integration_test/resident_toggle_test.dart -d linux

# Reset button test
flutter test integration_test/reset_button_test.dart -d linux
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
  ├── main.dart                 # Main app entry point
integration_test/
  ├── app_test.dart            # Comprehensive test suite
  ├── form_validation_test.dart # Individual validation test
  ├── resident_toggle_test.dart # Individual toggle test  
  └── reset_button_test.dart   # Individual reset test
.vscode/
  ├── launch.json             # VS Code debugger config
  └── tasks.json              # VS Code task runner config
```

## 🎯 Key Implementation Highlights

### Conditional Field Dependencies
- Fields can depend on other field values using `dependsOn` and `dependsValue`
- Real-time UI updates when dependency conditions change
- Form rebuilding triggered by state changes

### Form Validation Strategy
- Client-side validation using FormBuilder validators
- Custom validation rules for specific business logic
- Comprehensive error handling and user feedback

### Testing Approach  
- Widget testing for UI component verification
- Integration testing for end-to-end user workflows
- Debugger-friendly test structure for development

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Run tests (`flutter test integration_test/app_test.dart -d linux`)
4. Commit changes (`git commit -m 'Add AmazingFeature'`)
5. Push branch (`git push origin feature/AmazingFeature`)
6. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.