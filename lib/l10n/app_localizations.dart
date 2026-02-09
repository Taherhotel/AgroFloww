import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'app_title': 'AgroFlow',
      'hello': 'Hello',
      'farmer': 'Farmer',
      'plant_vitals': 'Plant Vitals',
      'features': 'Features',
      'inventory': 'Inventory',
      'seed_growth': 'Seed Growth',
      'disease_detection': 'Disease Detect',
      'items_available': 'items',
      'active_batches': 'batches',
      'check_health': 'Check health',
      'optimal': 'Optimal',
      'normal': 'Normal',
      'good': 'Good',
      'clear': 'Clear',
      'ph_level': 'pH Level',
      'tds': 'TDS',
      'dio': 'DIO',
      'turbidity': 'Turbidity',
      'temperature': 'Temperature',
      'hydroponic_knowledge': 'Hydroponic Knowledge',
      'about': 'About',
      'nutritional_benefits': 'Nutritional Benefits',
      'growth_parameters': 'Growth Parameters',
      'difficulty': 'Difficulty',
      'ph_range': 'pH Range',
      'ec_range': 'EC Range',
      'temp_range': 'Temp Range',
      'germination': 'Germination',
      'harvest': 'Harvest',
      'growth_plan': 'Growth Plan',
      'pro_tips': 'Pro Tips',
      'seed_growth_tips': 'Seed Growth',
      'knowledge_hub': 'Knowledge Hub',
    },
    'mr': {
      'app_title': 'AgroFLOW',
      'hello': 'नमस्कार',
      'farmer': 'शेतकरी',
      'plant_vitals': 'वनस्पतींची स्थिती',
      'features': 'वैशिष्ट्ये',
      'inventory': 'साठा (इन्व्हेंटरी)',
      'seed_growth': 'बियाणे वाढ',
      'disease_detection': 'रोग निदान',
      'items_available': 'वस्तू',
      'active_batches': 'बॅचेस',
      'check_health': 'आरोग्य तपासा',
      'optimal': 'उत्तम',
      'normal': 'सामान्य',
      'good': 'चांगले',
      'clear': 'स्वच्छ',
      'ph_level': 'pH स्तर',
      'tds': 'TDS',
      'dio': 'विरघळलेला ऑक्सिजन',
      'turbidity': 'गढूळपणा',
      'temperature': 'तापमान',
      'hydroponic_knowledge': 'हायड्रोपोनिक्स ज्ञान',
      'about': 'माहिती',
      'nutritional_benefits': 'पोषक फायदे',
      'growth_parameters': 'वाढीचे मापदंड',
      'difficulty': 'काठिण्य',
      'ph_range': 'pH श्रेणी',
      'ec_range': 'EC श्रेणी',
      'temp_range': 'तापमान श्रेणी',
      'germination': 'अंकुरण',
      'harvest': 'काढणी',
      'growth_plan': 'वाढीची योजना',
      'pro_tips': 'प्रो टिप्स',
      'knowledge_hub': 'ज्ञान केंद्र',
    },
    'hi': {
      'app_title': 'AgroFLOW',
      'hello': 'नमस्ते',
      'farmer': 'किसान',
      'plant_vitals': 'पौधों की स्थिति',
      'features': 'विशेषताएँ',
      'inventory': 'इन्वेंटरी',
      'seed_growth': 'बीज वृद्धि',
      'disease_detection': 'रोग पहचान',
      'items_available': 'वस्तुएं',
      'active_batches': 'बैच',
      'check_health': 'स्वास्थ्य जांचें',
      'optimal': 'इष्टतम',
      'normal': 'सामान्य',
      'good': 'अच्छा',
      'clear': 'साफ़',
      'ph_level': 'pH स्तर',
      'tds': 'TDS',
      'dio': 'घुलित ऑक्सीजन',
      'turbidity': 'गंदलापन',
      'temperature': 'तापमान',
      'hydroponic_knowledge': 'हाइड्रोपोनिक्स ज्ञान',
      'about': 'बारे में',
      'nutritional_benefits': 'पोषक लाभ',
      'growth_parameters': 'विकास के मापदंड',
      'difficulty': 'कठिनाई',
      'ph_range': 'pH रेंज',
      'ec_range': 'EC रेंज',
      'temp_range': 'तापमान रेंज',
      'germination': 'अंकुरण',
      'harvest': 'कटाई',
      'growth_plan': 'विकास योजना',
      'pro_tips': 'प्रो टिप्स',
      'knowledge_hub': 'ज्ञान केंद्र',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'mr', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
