import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class PredictionFormScreen extends StatefulWidget {
  const PredictionFormScreen({Key? key}) : super(key: key);

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _healthcareAccessController = TextEditingController();
  final _doctorsPerThousandController = TextEditingController();
  final _hospitalBedsController = TextEditingController();
  final _perCapitaIncomeController = TextEditingController();
  final _educationIndexController = TextEditingController();
  final _urbanizationRateController = TextEditingController();
  final _populationAffectedController = TextEditingController();
  final _dalysController = TextEditingController();
  final _improvementController = TextEditingController();
  final _treatmentCostController = TextEditingController();
  

  int _gender = 0;
  int _treatmentType = 0;
  
  String _predictionResult = "";
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void dispose() {
    _healthcareAccessController.dispose();
    _doctorsPerThousandController.dispose();
    _hospitalBedsController.dispose();
    _perCapitaIncomeController.dispose();
    _educationIndexController.dispose();
    _urbanizationRateController.dispose();
    _populationAffectedController.dispose();
    _dalysController.dispose();
    _improvementController.dispose();
    _treatmentCostController.dispose();
    super.dispose();
  }

  Future<void> _submitPrediction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _predictionResult = "";
        _hasError = false;
      });

      try {
        final response = await http.post(
          Uri.parse('https://modeltraining-summative.onrender.com/predict'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'healthcare_access': double.parse(_healthcareAccessController.text),
            'doctors_per_1000': double.parse(_doctorsPerThousandController.text),
            'hospital_beds_per_1000': double.parse(_hospitalBedsController.text),
            'per_capita_income': double.parse(_perCapitaIncomeController.text),
            'education_index': double.parse(_educationIndexController.text),
            'urbanization_rate': double.parse(_urbanizationRateController.text),
            'population_affected': int.parse(_populationAffectedController.text),
            'dalys': double.parse(_dalysController.text),
            'improvement_5_years': double.parse(_improvementController.text),
            'avg_treatment_cost': double.parse(_treatmentCostController.text),
            'gender': _gender,
            'treatment_type': _treatmentType,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _predictionResult = 'Predicted Disease Prevalence Rate: ${data['prevalence_rate'].toStringAsFixed(2)}%';
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _predictionResult = 'Error: ${response.statusCode} - ${response.body}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _hasError = true;
          _predictionResult = 'Error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Health Prediction Form'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Healthcare System',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // user's inputs
                          
                          _buildTextFormField(
                            controller: _healthcareAccessController,
                            label: 'Healthcare Access (%)',
                            hint: 'Enter value from 0-100',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 100) {
                                return 'Value must be between 0 and 100';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _doctorsPerThousandController,
                            label: 'Doctors per 1000 People',
                            hint: 'Enter value from 0-20',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 20) {
                                return 'Value must be between 0 and 20';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _hospitalBedsController,
                            label: 'Hospital Beds per 1000 People',
                            hint: 'Enter value from 0-20',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 20) {
                                return 'Value must be between 0 and 20';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Socioeconomic Factors',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextFormField(
                            controller: _perCapitaIncomeController,
                            label: 'Per Capita Income (USD)',
                            hint: 'Enter value up to 100000',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 100000) {
                                return 'Value must be between 0 and 100000';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _educationIndexController,
                            label: 'Education Index (0-1)',
                            hint: 'Enter value from 0-1',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 1) {
                                return 'Value must be between 0 and 1';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _urbanizationRateController,
                            label: 'Urbanization Rate (%)',
                            hint: 'Enter value from 0-100',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0 || numValue > 100) {
                                return 'Value must be between 0 and 100';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disease Factors',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextFormField(
                            controller: _populationAffectedController,
                            label: 'Population Affected',
                            hint: 'Enter number of people',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = int.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0) {
                                return 'Value must be 0 or greater';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _dalysController,
                            label: 'Disability-Adjusted Life Years',
                            hint: 'Enter DALY value',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0) {
                                return 'Value must be 0 or greater';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _improvementController,
                            label: 'Improvement in 5 Years (%)',
                            hint: 'Enter value from -100 to 100',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < -100 || numValue > 100) {
                                return 'Value must be between -100 and 100';
                              }
                              return null;
                            },
                          ),
                          
                          _buildTextFormField(
                            controller: _treatmentCostController,
                            label: 'Average Treatment Cost (USD)',
                            hint: 'Enter cost value',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (numValue < 0) {
                                return 'Value must be 0 or greater';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demographics & Treatment',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                            ),
                            value: _gender,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('Female')),
                              DropdownMenuItem(value: 1, child: Text('Male')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Treatment Type',
                            ),
                            value: _treatmentType,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('Type A')),
                              DropdownMenuItem(value: 1, child: Text('Type B')),
                              DropdownMenuItem(value: 2, child: Text('Type C')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _treatmentType = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  //Predict button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitPrediction,
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
                            'PREDICT',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  
                  const SizedBox(height: 24),
                  

                  // Results display
                  if (_predictionResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _hasError ? Colors.red.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _hasError ? Colors.red.shade300 : Colors.green.shade300,
                        ),
                      ),
                      child: Text(
                        _predictionResult,
                        style: TextStyle(
                          color: _hasError ? Colors.red.shade800 : Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}