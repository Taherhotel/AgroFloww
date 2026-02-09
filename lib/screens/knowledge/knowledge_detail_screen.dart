import 'package:flutter/material.dart';
import '../../models/plant_knowledge.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class KnowledgeDetailScreen extends StatelessWidget {
  final PlantKnowledge plant;

  const KnowledgeDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    // Helper to safely get localized string
    String loc(Map<String, String> map) => map[langCode] ?? map['en'] ?? '';
    // Helper to safely get localized list
    List<String> locList(Map<String, List<String>> map) =>
        map[langCode] ?? map['en'] ?? [];

    final localizedName = loc(plant.name);
    final localizedDesc = loc(plant.description);
    final localizedBenefits = locList(plant.nutritionalBenefits);
    final localizedSteps = locList(plant.guide.steps);
    final localizedTips = locList(plant.guide.tips);

    // Guide details
    final difficulty = loc(plant.guide.difficulty);
    final germination = loc(plant.guide.germinationTime);
    final harvest = loc(plant.guide.harvestTime);

    return Scaffold(
      appBar: AppBar(title: Text(localizedName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.eco, size: 64, color: AppTheme.primaryGreen),
                  const SizedBox(height: 12),
                  Text(
                    localizedName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  Text(
                    plant.scientificName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.brown.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              l10n.get('about'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(localizedDesc, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),

            // Nutritional Benefits
            _buildSectionHeader(
              context,
              l10n.get('nutritional_benefits'),
              Icons.favorite,
            ),
            const SizedBox(height: 12),
            ...localizedBenefits.map((benefit) => _buildBulletPoint(benefit)),
            const SizedBox(height: 24),

            // Hydroponic Guide Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          l10n.get('growth_parameters'),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildParameterRow(l10n.get('difficulty'), difficulty),
                    _buildParameterRow(
                      l10n.get('ph_range'),
                      plant.guide.phRange,
                    ),
                    _buildParameterRow(
                      l10n.get('ec_range'),
                      plant.guide.ecRange,
                    ),
                    _buildParameterRow(
                      l10n.get('temp_range'),
                      plant.guide.temperatureRange,
                    ),
                    _buildParameterRow(l10n.get('germination'), germination),
                    _buildParameterRow(l10n.get('harvest'), harvest),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Step by Step Plan
            _buildSectionHeader(
              context,
              l10n.get('growth_plan'),
              Icons.list_alt,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: localizedSteps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppTheme.secondaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localizedSteps[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Tips
            _buildSectionHeader(context, l10n.get('pro_tips'), Icons.lightbulb),
            const SizedBox(height: 12),
            ...localizedTips.map((tip) => _buildBulletPoint(tip)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
