import 'sensor_reading.dart';
import 'growth_prediction.dart';

enum GrowthStage { germination, seedling, vegetative, flowering, harvestReady }

extension GrowthStageExtension on GrowthStage {
  String get label {
    switch (this) {
      case GrowthStage.germination:
        return 'Germination';
      case GrowthStage.seedling:
        return 'Seedling';
      case GrowthStage.vegetative:
        return 'Vegetative';
      case GrowthStage.flowering:
        return 'Flowering';
      case GrowthStage.harvestReady:
        return 'Harvest Ready';
    }
  }
}

class CropBatch {
  final String id;
  final String name; // e.g., "Batch A - Spinach"
  final String plantType; // e.g., "Spinach", "Lettuce"
  final DateTime plantingDate;
  GrowthStage stage;
  DateTime? expectedHarvestDate;
  String? notes;
  bool isOptimizedFertilization;

  // AI/Smart Tracking fields
  SensorReading? lastSensorReading;
  GrowthPrediction? lastPrediction;

  CropBatch({
    required this.id,
    required this.name,
    required this.plantType,
    required this.plantingDate,
    this.stage = GrowthStage.germination,
    this.expectedHarvestDate,
    this.notes,
    this.isOptimizedFertilization = false,
    this.lastSensorReading,
    this.lastPrediction,
  });

  // Calculate predicted harvest date based on fertilization or AI prediction
  DateTime? get predictedHarvestDate {
    // If AI prediction exists, prioritize it
    if (lastPrediction != null) {
      return lastPrediction!.predictedHarvestDate;
    }

    if (expectedHarvestDate == null) return null;

    if (isOptimizedFertilization) {
      // Logic: Optimized fertilization reduces remaining time by ~15%
      // or simply reduces total growth cycle.
      // Let's assume it saves 10% of the total time if applied from start,
      // or simplified: reduces remaining time.

      final totalDuration = expectedHarvestDate!
          .difference(plantingDate)
          .inDays;
      final savedDays = (totalDuration * 0.15).round(); // 15% faster
      return expectedHarvestDate!.subtract(Duration(days: savedDays));
    }
    return expectedHarvestDate;
  }
}
