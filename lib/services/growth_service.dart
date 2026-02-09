import 'package:flutter/material.dart';
import '../models/crop_batch.dart';
import '../models/sensor_reading.dart';
import '../models/growth_prediction.dart';

class GrowthService extends ChangeNotifier {
  // Singleton pattern
  static final GrowthService _instance = GrowthService._internal();
  factory GrowthService() => _instance;
  GrowthService._internal();

  final List<CropBatch> _batches = [
    // Mock data
    CropBatch(
      id: '1',
      name: 'Batch A - Spinach',
      plantType: 'Spinach',
      plantingDate: DateTime.now().subtract(const Duration(days: 5)),
      stage: GrowthStage.seedling,
      expectedHarvestDate: DateTime.now().add(const Duration(days: 25)),
    ),
    CropBatch(
      id: '2',
      name: 'Batch B - Lettuce',
      plantType: 'Lettuce',
      plantingDate: DateTime.now().subtract(const Duration(days: 15)),
      stage: GrowthStage.vegetative,
      expectedHarvestDate: DateTime.now().add(const Duration(days: 15)),
    ),
  ];

  List<CropBatch> get batches => List.unmodifiable(_batches);

  int get activeBatchesCount => _batches.length;

  void addBatch(CropBatch batch) {
    _batches.add(batch);
    notifyListeners();
  }

  void updateStage(String id, GrowthStage newStage) {
    final index = _batches.indexWhere((b) => b.id == id);
    if (index != -1) {
      _batches[index].stage = newStage;
      notifyListeners();
    }
  }

  void toggleOptimization(String id) {
    final index = _batches.indexWhere((b) => b.id == id);
    if (index != -1) {
      _batches[index].isOptimizedFertilization =
          !_batches[index].isOptimizedFertilization;
      notifyListeners();
    }
  }

  void removeBatch(String id) {
    _batches.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // AI Growth Prediction Logic
  void updateSensorReading(String batchId, SensorReading reading) {
    final index = _batches.indexWhere((b) => b.id == batchId);
    if (index != -1) {
      final batch = _batches[index];

      // Generate AI Prediction based on reading
      final prediction = _generatePrediction(batch, reading);

      // Create a new batch instance with updated data (since fields are final-ish but we can mutate or replace)
      // Actually, let's just update the fields if they were mutable, but they are final in my previous edit?
      // Wait, in CropBatch they are final fields?
      // Checking CropBatch definition...
      // "SensorReading? lastSensorReading;" and "GrowthPrediction? lastPrediction;" are fields I added.
      // I defined them as:
      // final String id; ...
      // SensorReading? lastSensorReading;
      // GrowthPrediction? lastPrediction;
      // Ah, I made them mutable (no final keyword) in my thought process?
      // Let me check the file content of CropBatch again to be sure.

      _batches[index].lastSensorReading = reading;
      _batches[index].lastPrediction = prediction;

      notifyListeners();
    }
  }

  GrowthPrediction _generatePrediction(CropBatch batch, SensorReading reading) {
    // 1. Analyze Environment
    double healthScore = 1.0;
    double growthRate = 1.0;
    List<String> plan = [];
    String status = "Optimal Conditions";

    // Ideal ranges (Simplified Knowledge Base for Hydroponics)
    double idealTempMin = 18;
    double idealTempMax = 24;
    double idealPhMin = 5.5;
    double idealPhMax = 6.5;
    double idealEcMin = 1.2;
    double idealEcMax = 2.4;

    // Adjust based on plant type
    if (batch.plantType.toLowerCase().contains('spinach')) {
      idealTempMin = 15;
      idealTempMax = 22;
      idealPhMin = 5.5;
      idealPhMax = 6.5;
      idealEcMin = 1.0;
      idealEcMax = 1.6;
    } else if (batch.plantType.toLowerCase().contains('tomato')) {
      idealTempMin = 20;
      idealTempMax = 26;
      idealPhMin = 5.5;
      idealPhMax = 6.5;
      idealEcMin = 2.0;
      idealEcMax = 3.5;
    } else if (batch.plantType.toLowerCase().contains('lettuce')) {
      idealTempMin = 16;
      idealTempMax = 22;
      idealPhMin = 5.5;
      idealPhMax = 6.0;
      idealEcMin = 0.8;
      idealEcMax = 1.2;
    }

    // Ambient Temp Check
    if (reading.temperature < idealTempMin) {
      healthScore -= 0.1;
      growthRate -= 0.2;
      plan.add("Ambient temperature too low. Consider heating the grow area.");
      status = "Cold Stress Detected";
    } else if (reading.temperature > idealTempMax) {
      healthScore -= 0.2;
      growthRate -= 0.3;
      plan.add("Ambient temperature too high. Increase ventilation.");
      status = "Heat Stress Detected";
    }

    // Water Temp Check
    if (reading.waterTemperature > 25) {
      healthScore -= 0.1;
      plan.add(
        "Water temperature too high (>25°C). Risk of root rot. Add chiller or ice.",
      );
      if (status == "Optimal Conditions") status = "Water Temp High";
    }

    // pH Check
    if (reading.phLevel < idealPhMin) {
      healthScore -= 0.2;
      plan.add("pH too low (${reading.phLevel}). Add pH Up (Base).");
      if (status == "Optimal Conditions") status = "pH Imbalance";
    } else if (reading.phLevel > idealPhMax) {
      healthScore -= 0.2;
      plan.add("pH too high (${reading.phLevel}). Add pH Down (Acid).");
      if (status == "Optimal Conditions") status = "pH Imbalance";
    }

    // EC Check
    if (reading.ecLevel < idealEcMin) {
      healthScore -= 0.1;
      growthRate -= 0.1;
      plan.add("EC too low (${reading.ecLevel} mS/cm). Add nutrients.");
      if (status == "Optimal Conditions") status = "Nutrient Deficiency";
    } else if (reading.ecLevel > idealEcMax) {
      healthScore -= 0.15;
      plan.add(
        "EC too high (${reading.ecLevel} mS/cm). Dilute with fresh water.",
      );
      if (status == "Optimal Conditions") status = "Nutrient Burn Risk";
    }

    // 2. Calculate Dates
    // Base harvest date
    DateTime targetHarvest =
        batch.expectedHarvestDate ??
        DateTime.now().add(const Duration(days: 30));

    // Adjust based on growth rate
    // If growth rate is 0.8 (slow), remaining days increase by 20%
    final remainingDays = targetHarvest.difference(DateTime.now()).inDays;
    final adjustedRemainingDays = (remainingDays / growthRate).round();
    final predictedHarvest = DateTime.now().add(
      Duration(days: adjustedRemainingDays),
    );

    // Fertilization Schedule
    // Simple rule: Fertilize every 14 days, unless stressed
    DateTime nextFertilize = DateTime.now().add(const Duration(days: 7));
    if (healthScore < 0.8) {
      plan.add("Delay fertilization until plant recovers from stress.");
      nextFertilize = DateTime.now().add(const Duration(days: 14));
    } else {
      plan.add(
        "Apply balanced liquid fertilizer on ${nextFertilize.toString().split(' ')[0]}.",
      );
    }

    if (plan.isEmpty) {
      plan.add("Continue current care routine.");
    }

    return GrowthPrediction(
      predictedHarvestDate: predictedHarvest,
      nextFertilizationDate: nextFertilize,
      growthRateMultiplier: growthRate,
      healthScore: healthScore,
      smartPlan: plan,
      statusMessage: status,
    );
  }
}
