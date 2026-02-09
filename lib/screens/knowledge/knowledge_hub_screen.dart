import 'package:flutter/material.dart';
import '../../services/knowledge_service.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'knowledge_detail_screen.dart';

class KnowledgeHubScreen extends StatelessWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = KnowledgeService.leafyVeggies;
    final langCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('hydroponic_knowledge'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          final localizedName = plant.name[langCode] ?? plant.name['en'] ?? '';
          final localizedDesc =
              plant.description[langCode] ?? plant.description['en'] ?? '';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => KnowledgeDetailScreen(plant: plant),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryGreen.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        localizedName.isNotEmpty ? localizedName[0] : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizedName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown.shade800,
                                ),
                          ),
                          Text(
                            plant.scientificName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizedDesc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
