import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SensorData {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<String?> fetchData(String path) async {
    try {
      DatabaseEvent event = await _databaseReference.child(path).once();
      DataSnapshot snapshot = event.snapshot;

      return snapshot.value.toString();
    } catch (error, stacktrace) {
      logger.e('Error fetching data from $path',
          error: error, stackTrace: stacktrace);
      return null;
    }
  }

  Future<void> fetchAllSensorData() async {
    await fetchTemperatureData();
    await fetchHumidityData();
    await fetchSoilMoistureData();
    await fetchWaterLevelData();
    await fetchWaterPumpData();
  }

  Future<String?> fetchTemperatureData() async {
    return fetchData('dht/temperature');
  }

  Future<String?> fetchHumidityData() async {
    return fetchData('dht/humidity');
  }

  Future<String?> fetchSoilMoistureData() async {
    return fetchData('soil_moisture');
  }

  Future<String?> fetchWaterLevelData() async {
    return fetchData('water_level');
  }

  Future<String?> fetchWaterPumpData() async {
    return fetchData('water_pump');
  }
}
