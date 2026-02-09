import 'package:flutter/material.dart';
import '../../services/growth_service.dart';
import '../../models/crop_batch.dart';
import '../../models/sensor_reading.dart'; // Added
import '../../theme/app_theme.dart';
import 'add_crop_screen.dart';
import 'package:intl/intl.dart';

class GrowthTrackingScreen extends StatelessWidget {
  const GrowthTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seed Growth Tracking')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddCropScreen()),
          );
        },
        label: const Text('New Batch'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: GrowthService(),
        builder: (context, child) {
          final batches = GrowthService().batches;

          if (batches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active crops',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Start tracking your seeds now'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryGreen
                                    .withValues(alpha: 0.1),
                                child: const Icon(
                                  Icons.eco,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batch.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    batch.plantType,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              batch.stage.label,
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // AI Prediction Section
                      if (batch.lastPrediction != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "AI Growth Prediction",
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.calendar_today,
                                "Est. Harvest:",
                                DateFormat(
                                  'MMM d, y',
                                ).format(batch.predictedHarvestDate!),
                              ),
                              _buildInfoRow(
                                Icons.water_drop,
                                "Next Nutrient Top-up:",
                                DateFormat('MMM d').format(
                                  batch.lastPrediction!.nextFertilizationDate,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Smart Plan:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              ...batch.lastPrediction!.smartPlan.map(
                                (plan) => Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "• ",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Expanded(
                                        child: Text(
                                          plan,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _showSensorDialog(context, batch),
                              icon: const Icon(Icons.sensors),
                              label: const Text('Analyze Sensors'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryGreen,
                                side: const BorderSide(
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showSensorDialog(BuildContext context, CropBatch batch) {
    double temp = 22;
    double waterTemp = 20;
    double ph = 6.0;
    double ec = 1.2;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Input Hydroponic Data'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Simulate readings from Hydroponic sensors:'),
                    const SizedBox(height: 16),

                    // Ambient Temperature
                    Row(
                      children: [
                        const Icon(Icons.thermostat, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('Ambient Temp: ${temp.toStringAsFixed(1)}°C'),
                      ],
                    ),
                    Slider(
                      value: temp,
                      min: 10,
                      max: 40,
                      divisions: 60,
                      label: temp.toStringAsFixed(1),
                      onChanged: (v) => setState(() => temp = v),
                    ),

                    // Water Temperature
                    Row(
                      children: [
                        const Icon(Icons.water, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Water Temp: ${waterTemp.toStringAsFixed(1)}°C'),
                      ],
                    ),
                    Slider(
                      value: waterTemp,
                      min: 10,
                      max: 35,
                      divisions: 50,
                      label: waterTemp.toStringAsFixed(1),
                      onChanged: (v) => setState(() => waterTemp = v),
                    ),

                    // pH Level
                    Row(
                      children: [
                        const Icon(Icons.science, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text('pH Level: ${ph.toStringAsFixed(1)}'),
                      ],
                    ),
                    Slider(
                      value: ph,
                      min: 0,
                      max: 14,
                      divisions: 140,
                      label: ph.toStringAsFixed(1),
                      onChanged: (v) => setState(() => ph = v),
                    ),

                    // EC Level
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.yellow),
                        const SizedBox(width: 8),
                        Text('EC Level: ${ec.toStringAsFixed(1)} mS/cm'),
                      ],
                    ),
                    Slider(
                      value: ec,
                      min: 0,
                      max: 5.0,
                      divisions: 50,
                      label: ec.toStringAsFixed(1),
                      onChanged: (v) => setState(() => ec = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final reading = SensorReading(
                      timestamp: DateTime.now(),
                      temperature: temp,
                      humidity: 60, // Default
                      phLevel: ph,
                      ecLevel: ec,
                      waterTemperature: waterTemp,
                      lightLevel: 500, // Default
                    );
                    GrowthService().updateSensorReading(batch.id, reading);
                    Navigator.pop(context);
                  },
                  child: const Text('Analyze'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
