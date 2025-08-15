import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:split_view/split_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON to Form Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const JsonToFormScreen(),
    );
  }
}

class JsonToFormScreen extends StatefulWidget {
  const JsonToFormScreen({super.key});

  @override
  State<JsonToFormScreen> createState() => _JsonToFormScreenState();
}

class _JsonToFormScreenState extends State<JsonToFormScreen> {
  final TextEditingController _jsonController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic>? _jsonData;
  String? _errorMessage;
  bool _isUpdatingMutualExclusion = false; // Prevent infinite loops

  final String _defaultJson = '''{
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
      "name": "lastName",
      "type": "text",
      "label": "Last Name",
      "required": true,
      "placeholder": "Enter your last name"
    },
    {
      "name": "email",
      "type": "email",
      "label": "Email Address",
      "required": true,
      "placeholder": "Enter your email"
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
      "name": "gender",
      "type": "dropdown",
      "label": "Gender",
      "required": false,
      "options": ["Male", "Female", "Other", "Prefer not to say"]
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
}''';

  @override
  void initState() {
    super.initState();
    _jsonController.text = _defaultJson;
    _generateForm();
  }

  void _generateForm() {
    setState(() {
      _errorMessage = null;
      try {
        final jsonString = _jsonController.text.trim();
        if (jsonString.isEmpty) {
          throw Exception('JSON input cannot be empty');
        }
        
        _jsonData = json.decode(jsonString) as Map<String, dynamic>;
        
        if (!_jsonData!.containsKey('fields') || _jsonData!['fields'] is! List) {
          throw Exception('JSON must contain a "fields" array');
        }
        
        print('Form generated successfully with ${(_jsonData!['fields'] as List).length} fields');
      } catch (e) {
        _jsonData = null;
        _errorMessage = 'JSON Parse Error: ${e.toString()}';
        print('Error parsing JSON: $_errorMessage');
      }
    });
  }

  String _formatJson(String jsonString) {
    try {
      final dynamic jsonData = json.decode(jsonString);
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonData);
    } catch (e) {
      print('Error formatting JSON: ${e.toString()}');
      return jsonString;
    }
  }

  void _formatJsonInput() {
    try {
      final formatted = _formatJson(_jsonController.text);
      setState(() {
        _jsonController.text = formatted;
      });
    } catch (e) {
      print('Failed to format JSON: ${e.toString()}');
    }
  }

  Widget _buildJsonPanel() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'JSON Configuration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _formatJsonInput,
                icon: const Icon(Icons.code),
                label: const Text('Format'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _jsonController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your JSON configuration here...',
              ),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _generateForm,
            icon: const Icon(Icons.refresh),
            label: const Text('Generate Form'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(Map<String, dynamic> fieldConfig) {
    final String name = fieldConfig['name'] ?? '';
    final String type = fieldConfig['type'] ?? 'text';
    final String label = fieldConfig['label'] ?? name;
    final bool required = fieldConfig['required'] ?? false;
    final String? placeholder = fieldConfig['placeholder'];
    final dynamic defaultValue = fieldConfig['defaultValue'];
    final String? defaultStringValue = (type == 'text' || type == 'email') ? defaultValue?.toString() : null;
    
    // Check if this field should be disabled based on other field values
    final String? dependsOn = fieldConfig['dependsOn'];
    final dynamic dependsValue = fieldConfig['dependsValue'];
    bool isEnabled = true;
    
    if (dependsOn != null && _formKey.currentState != null) {
      final currentValue = _formKey.currentState!.fields[dependsOn]?.value;
      isEnabled = currentValue == dependsValue;
    }

    try {
      switch (type.toLowerCase()) {
        case 'text':
        case 'email':
          return FormBuilderTextField(
            name: name,
            key: ValueKey(name),
            initialValue: defaultStringValue,
            decoration: InputDecoration(
              labelText: label,
              hintText: placeholder,
              border: const OutlineInputBorder(),
            ),
            validator: required
                ? FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    if (type == 'email') FormBuilderValidators.email(),
                  ])
                : null,
          );

        case 'number':
          return FormBuilderTextField(
            name: name,
            key: ValueKey(name),
            decoration: InputDecoration(
              labelText: label,
              hintText: placeholder,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: required
                ? FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    if (fieldConfig['min'] != null)
                      FormBuilderValidators.min(fieldConfig['min']),
                    if (fieldConfig['max'] != null)
                      FormBuilderValidators.max(fieldConfig['max']),
                  ])
                : FormBuilderValidators.numeric(),
          );

        case 'dropdown':
          final List<String> options = (fieldConfig['options'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          return FormBuilderDropdown<String>(
            name: name,
            key: ValueKey(name),
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            validator: required ? FormBuilderValidators.required() : null,
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
          );

        case 'checkbox':
          return FormBuilderCheckbox(
            name: name,
            key: ValueKey(name),
            title: Text(label),
            enabled: isEnabled,
            validator: required ? FormBuilderValidators.required() : null,
          );

        case 'toggle':
          return FormBuilderSwitch(
            name: name,
            key: ValueKey(name),
            title: Text(label),
            initialValue: fieldConfig['defaultValue'] ?? false,
            enabled: isEnabled,
            validator: required ? FormBuilderValidators.required() : null,
            onChanged: (value) {
              // Prevent infinite loops in mutual exclusion
              if (_isUpdatingMutualExclusion) return;
              
              // Handle mutual exclusion - ensure exactly one toggle is always ON
              final String? togglesOff = fieldConfig['togglesOff'];
              if (togglesOff != null && _formKey.currentState != null) {
                _isUpdatingMutualExclusion = true; // Set flag to prevent recursion
                
                if (value == true) {
                  // Turn off the other toggle when this one is turned ON
                  _formKey.currentState!.fields[togglesOff]?.didChange(false);
                } else {
                  // Turn on the other toggle when this one is turned OFF (mutual exclusion)
                  _formKey.currentState!.fields[togglesOff]?.didChange(true);
                }
                
                _isUpdatingMutualExclusion = false; // Clear flag after update
              }
              
              // Trigger a rebuild to update dependent fields
              setState(() {});
            },
          );

        default:
          return FormBuilderTextField(
            name: name,
            decoration: InputDecoration(
              labelText: '$label (unsupported type: $type)',
              border: const OutlineInputBorder(),
              errorText: 'Unsupported field type: $type',
            ),
          );
      }
    } catch (e) {
      print('Error building field $name: ${e.toString()}');
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Error building field "$name": ${e.toString()}'),
        ),
      );
    }
  }

  List<Widget> _buildGroupedFields() {
    final fields = (_jsonData!['fields'] as List)
        .where((field) => field is Map<String, dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();

    // Group fields by group name
    final Map<String, List<Map<String, dynamic>>> groupedFields = {};
    for (final field in fields) {
      final groupName = field['group'] as String? ?? '';
      groupedFields.putIfAbsent(groupName, () => []).add(field);
    }

    final List<Widget> widgets = [];
    
    // Add ungrouped fields first (fields without group)
    if (groupedFields.containsKey('')) {
      widgets.addAll(
        groupedFields['']!.map((field) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildFormField(field),
        ))
      );
    }

    // Add grouped fields
    for (final entry in groupedFields.entries) {
      if (entry.key.isEmpty) continue; // Skip ungrouped fields (already added)
      
      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                ...entry.value.map((field) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildFormField(field),
                )),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildFormPanel() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Generated Form',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _errorMessage != null
                ? Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                : _jsonData == null
                    ? const Center(child: Text('No form data available'))
                    : SingleChildScrollView(
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (_jsonData!['title'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    _jsonData!['title'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ..._buildGroupedFields(),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        try {
                                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                                            final formData = _formKey.currentState!.value;
                                            print('Form submitted successfully: ${json.encode(formData)}');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Form submitted successfully!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } else {
                                            print('Form validation failed');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fix form errors'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          print('Error submitting form: ${e.toString()}');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      try {
                                        _formKey.currentState?.reset();
                                        print('Form reset successfully');
                                      } catch (e) {
                                        print('Error resetting form: ${e.toString()}');
                                      }
                                    },
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON to Form Builder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        indicator: const SplitIndicator(viewMode: SplitViewMode.Horizontal),
        activeIndicator: const SplitIndicator(
          viewMode: SplitViewMode.Horizontal,
          isActive: true,
        ),
        children: [
          _buildJsonPanel(),
          _buildFormPanel(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }
}