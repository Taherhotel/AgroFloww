import 'package:flutter/material.dart';
import '../../services/growth_service.dart';
import '../../models/crop_batch.dart';
import '../../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedPlantType;
  DateTime _plantingDate = DateTime.now();
  DateTime? _harvestDate;

  final List<String> _plantTypes = [
    'Lettuce',
    'Spinach',
    'Tomato',
    'Basil',
    'Cucumber',
    'Pepper',
    'Strawberry',
    'Mint',
    'Kale',
    'Chard',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPlanting) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPlanting
          ? _plantingDate
          : (_harvestDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isPlanting) {
          _plantingDate = picked;
        } else {
          _harvestDate = picked;
        }
      });
    }
  }

  void _saveCrop() {
    if (_formKey.currentState!.validate()) {
      final newBatch = CropBatch(
        id: const Uuid().v4(),
        name: _nameController.text,
        plantType: _selectedPlantType ?? 'Unknown',
        plantingDate: _plantingDate,
        expectedHarvestDate: _harvestDate,
        stage: GrowthStage.germination,
      );

      GrowthService().addBatch(newBatch);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('New crop batch started!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Crop Batch')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Batch Name',
                  hintText: 'e.g., Spring Spinach Batch 1',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedPlantType,
                decoration: const InputDecoration(
                  labelText: 'Select Plant',
                  prefixIcon: Icon(Icons.eco),
                ),
                items: _plantTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlantType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a plant type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('Planting Date'),
                subtitle: Text(DateFormat.yMMMd().format(_plantingDate)),
                leading: const Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryGreen,
                ),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Expected Harvest Date (Optional)'),
                subtitle: Text(
                  _harvestDate != null
                      ? DateFormat.yMMMd().format(_harvestDate!)
                      : 'Not set',
                ),
                leading: const Icon(
                  Icons.event,
                  color: AppTheme.secondaryGreen,
                ),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCrop,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Start Tracking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
