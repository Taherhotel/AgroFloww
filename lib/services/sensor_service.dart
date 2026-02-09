import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_reading.dart';

class SensorService {
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Not strictly needed if public path, but good for auth context if rules change

  // Stream of the latest sensor reading for the current user (or global demo device)
  Stream<SensorReading?> get latestReadingStream {
    // Note: We removed the user auth check because the Arduino writes to a public path 'hydroponics/mint/latest'.
    // This ensures that even the Demo Account (which might not have a real Firebase UID or specific sensor data)
    // can see the live data from the hardware.

    // Listening to: hydroponics/mint/latest
    return _rtdb.ref('hydroponics/mint/latest').onValue.map((event) {
      if (event.snapshot.value != null) {
        // Handle Map<dynamic, dynamic> from RTDB
        try {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);

          // Helper to safely parse numbers that might be int or double
          double parseDouble(dynamic value) {
            if (value == null) return 0.0;
            if (value is int) return value.toDouble();
            if (value is double) return value;
            if (value is String) return double.tryParse(value) ?? 0.0;
            return 0.0;
          }

          // Check if probes are down to determine if we should show sensor data or "Measuring..."
          final bool probesDown = data['probes_down'] ?? false;
          final double temp = parseDouble(data['temperature_C']);

          // If probes are up, we might receive null/NAN for ph/tds/turb in Arduino,
          // but let's just parse what's there. The Arduino code sends ph/tds/ntu ONLY if probesDown is true.

          return SensorReading(
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
            ),
            temperature: temp,
            humidity: 0.0, // Not provided by Arduino
            phLevel: parseDouble(data['pH']),
            ecLevel:
                0.0, // Not directly provided, could be derived from TDS if needed (TDS / 500 or similar)
            waterTemperature: temp, // Using same temp sensor for now
            lightLevel: 0.0, // Not provided
            tds: parseDouble(data['tds_ppm']),
            dio: 6.0, // Hardcoded ideal constant in Arduino code (DO_IDEAL)
            turbidity: parseDouble(data['turb_ntu']),
          );
        } catch (e) {
          // If data structure is different (e.g. list or nested), return null
          return null;
        }
      }
      return null;
    });
  }
}
