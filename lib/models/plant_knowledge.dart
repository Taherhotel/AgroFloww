class PlantKnowledge {
  final String id;
  final Map<String, String> name; // Localized
  final String scientificName;
  final Map<String, String> description; // Localized
  final Map<String, List<String>> nutritionalBenefits; // Localized
  final HydroponicGuide guide;
  final String imageUrl; // Placeholder for asset path

  PlantKnowledge({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.nutritionalBenefits,
    required this.guide,
    this.imageUrl = 'assets/logo.png', // Default
  });
}

class HydroponicGuide {
  final Map<String, String> difficulty; // Localized
  final Map<String, String> germinationTime; // Localized
  final Map<String, String> harvestTime; // Localized
  final String phRange; // Numbers usually don't need localization, but ranges might
  final String ecRange;
  final String temperatureRange;
  final Map<String, List<String>> steps; // Localized
  final Map<String, List<String>> tips; // Localized

  HydroponicGuide({
    required this.difficulty,
    required this.germinationTime,
    required this.harvestTime,
    required this.phRange,
    required this.ecRange,
    required this.temperatureRange,
    required this.steps,
    required this.tips,
  });
}
