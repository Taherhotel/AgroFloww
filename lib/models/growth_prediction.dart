class GrowthPrediction {
  final DateTime predictedHarvestDate;
  final DateTime nextFertilizationDate;
  final double growthRateMultiplier; // 1.0 = normal, <1.0 = slow, >1.0 = fast
  final double healthScore; // 0.0 - 1.0
  final List<String> smartPlan; // Actionable steps
  final String statusMessage; // Summary

  GrowthPrediction({
    required this.predictedHarvestDate,
    required this.nextFertilizationDate,
    required this.growthRateMultiplier,
    required this.healthScore,
    required this.smartPlan,
    required this.statusMessage,
  });
}
