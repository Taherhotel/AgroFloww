import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/inventory_service.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/growth_service.dart';
import '../services/language_service.dart'; // Added
import '../services/sensor_service.dart'; // Added
import '../models/sensor_reading.dart'; // Added
import '../l10n/app_localizations.dart'; // Added
import 'inventory/inventory_screen.dart';
import 'growth/growth_tracking_screen.dart';
import 'disease_detection/disease_detection_screen.dart';
import 'knowledge/knowledge_hub_screen.dart'; // Added

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userService = UserService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context).get('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Language Switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String code) {
              LanguageService().changeLanguage(code);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'en', child: Text('English')),
              const PopupMenuItem<String>(
                value: 'mr',
                child: Text('मराठी (Marathi)'),
              ),
              const PopupMenuItem<String>(
                value: 'hi',
                child: Text('हिंदी (Hindi)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Welcome Section
            StreamBuilder<UserModel?>(
              stream: user != null
                  ? userService.getUserStream(user.uid)
                  : Stream.value(null),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final displayName = userData?.name ?? 'Farmer'; // Fallback

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryGreen,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context).get('hello')},',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.brown.shade600),
                          ),
                          Text(
                            displayName == 'Farmer'
                                ? AppLocalizations.of(context).get('farmer')
                                : displayName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            Text(
              AppLocalizations.of(context).get('plant_vitals'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),

            // Sensor List (Vertical)
            StreamBuilder<SensorReading?>(
              stream: SensorService().latestReadingStream,
              builder: (context, snapshot) {
                final reading = snapshot.data;
                // Default values if no data (using 0.0 as marker for "no data" or loading)
                final ph = reading?.phLevel ?? 0.0;
                final tds = reading?.tds ?? 0.0;
                final dio = reading?.dio ?? 0.0;
                final turbidity = reading?.turbidity ?? 0.0;
                final temp = reading?.temperature ?? 0.0;

                // Simple helper to determine status label based on value
                // In a real app, this would be more complex logic
                String getStatus(double value, double min, double max) {
                  if (value == 0.0)
                    return AppLocalizations.of(context).get('normal');
                  if (value >= min && value <= max)
                    return AppLocalizations.of(context).get('optimal');
                  return AppLocalizations.of(context).get('good');
                }

                return Column(
                  children: [
                    _buildSensorCard(
                      context,
                      Icons.science,
                      AppLocalizations.of(context).get('ph_level'),
                      ph == 0.0 ? '--' : ph.toStringAsFixed(1),
                      getStatus(ph, 5.5, 6.5),
                    ),
                    _buildSensorCard(
                      context,
                      Icons.grain,
                      AppLocalizations.of(context).get('tds'),
                      tds == 0.0 ? '-- ppm' : '${tds.toStringAsFixed(0)} ppm',
                      getStatus(tds, 300, 800),
                    ),
                    _buildSensorCard(
                      context,
                      Icons.bubble_chart,
                      AppLocalizations.of(context).get('dio'),
                      dio == 0.0 ? '-- mg/L' : '${dio.toStringAsFixed(1)} mg/L',
                      getStatus(dio, 6.0, 9.0),
                    ),
                    _buildSensorCard(
                      context,
                      Icons.opacity,
                      AppLocalizations.of(context).get('turbidity'),
                      turbidity == 0.0
                          ? '-- NTU'
                          : '${turbidity.toStringAsFixed(0)} NTU',
                      getStatus(turbidity, 0, 5),
                    ),
                    _buildSensorCard(
                      context,
                      Icons.thermostat,
                      AppLocalizations.of(context).get('temperature'),
                      temp == 0.0 ? '--°C' : '${temp.toStringAsFixed(1)}°C',
                      getStatus(temp, 18, 26),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              AppLocalizations.of(context).get('features'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),

            // Features Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0, // Square
              children: [
                // Inventory Card
                ListenableBuilder(
                  listenable: InventoryService(),
                  builder: (context, child) {
                    final count = InventoryService().totalItems;
                    return _buildSquareFeatureCard(
                      context,
                      title: AppLocalizations.of(context).get('inventory'),
                      subtitle:
                          '$count ${AppLocalizations.of(context).get('items_available')}',
                      icon: Icons.inventory,
                      color: AppTheme.primaryGreen,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const InventoryScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Seed Growth Card
                ListenableBuilder(
                  listenable: GrowthService(),
                  builder: (context, child) {
                    final count = GrowthService().activeBatchesCount;
                    return _buildSquareFeatureCard(
                      context,
                      title: AppLocalizations.of(context).get('seed_growth'),
                      subtitle:
                          '$count ${AppLocalizations.of(context).get('active_batches')}',
                      icon: Icons.eco,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GrowthTrackingScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Disease Detection Card
                _buildSquareFeatureCard(
                  context,
                  title: AppLocalizations.of(context).get('disease_detection'),
                  subtitle: AppLocalizations.of(context).get('check_health'),
                  icon: Icons.health_and_safety,
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DiseaseDetectionScreen(),
                      ),
                    );
                  },
                ),

                // Knowledge Hub Card
                _buildSquareFeatureCard(
                  context,
                  title: AppLocalizations.of(context).get('knowledge_hub'),
                  subtitle: AppLocalizations.of(context).get('learn_grow'),
                  icon: Icons.school,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const KnowledgeHubScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.brown.shade600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String status,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.secondaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: AppTheme.secondaryGreen),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
