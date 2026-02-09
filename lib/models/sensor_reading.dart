class SensorReading {
  final DateTime timestamp;
  final double temperature; // Celsius (Ambient or Water)
  final double humidity; // Percentage (Ambient)
  final double phLevel; // 0.0 - 14.0
  final double ecLevel; // Electrical Conductivity (mS/cm)
  final double waterTemperature; // Celsius
  final double lightLevel; // Lux or scale 0-100
  final double tds; // Total Dissolved Solids (ppm)
  final double dio; // Dissolved Oxygen (mg/L)
  final double turbidity; // NTU (Nephelometric Turbidity Units)

  SensorReading({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.phLevel,
    required this.ecLevel,
    required this.waterTemperature,
    required this.lightLevel,
    this.tds = 0.0,
    this.dio = 0.0,
    this.turbidity = 0.0,
  });

  factory SensorReading.fromMap(Map<String, dynamic> map) {
    return SensorReading(
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as dynamic).toDate()
          : DateTime.now(),
      temperature: (map['temperature'] ?? 0).toDouble(),
      humidity: (map['humidity'] ?? 0).toDouble(),
      phLevel: (map['ph'] ?? 0).toDouble(),
      ecLevel: (map['ec'] ?? 0).toDouble(),
      waterTemperature: (map['water_temperature'] ?? 0).toDouble(),
      lightLevel: (map['light_level'] ?? 0).toDouble(),
      tds: (map['tds'] ?? 0).toDouble(),
      dio: (map['dio'] ?? 0).toDouble(),
      turbidity: (map['turbidity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'temperature': temperature,
      'humidity': humidity,
      'ph': phLevel,
      'ec': ecLevel,
      'water_temperature': waterTemperature,
      'light_level': lightLevel,
      'tds': tds,
      'dio': dio,
      'turbidity': turbidity,
    };
  }
}
