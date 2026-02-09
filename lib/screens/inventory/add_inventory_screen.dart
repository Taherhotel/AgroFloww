import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/inventory_item.dart';
import '../../services/inventory_service.dart';
import '../../theme/app_theme.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();

  String _selectedVeggie = 'Spinach';
  String _selectedUnit = 'kg';

  final List<String> _leafyVeggies = [
    'Spinach',
    'Lettuce',
    'Kale',
    'Cabbage',
    'Swiss Chard',
    'Arugula',
    'Bok Choy',
    'Collard Greens',
    'Mustard Greens',
    'Coriander',
    'Mint',
    'Other',
  ];

  final List<String> _units = ['kg', 'bunches', 'grams', 'lbs'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final item = InventoryItem(
        id: const Uuid().v4(),
        name: _selectedVeggie,
        category: 'Leafy Veggie',
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        dateAdded: DateTime.now(),
      );

      InventoryService().addItem(item);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item added to inventory')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Leafy Vegetable')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: AppTheme.surfaceBeige,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.eco,
                        size: 48,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add to Inventory',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                initialValue: _selectedVeggie,
                decoration: const InputDecoration(
                  labelText: 'Select Vegetable',
                  prefixIcon: Icon(Icons.grass),
                ),
                items: _leafyVeggies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVeggie = newValue!;
                  });
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.scale),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: _units.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _saveItem,
                icon: const Icon(Icons.save),
                label: const Text('Add to Inventory'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
