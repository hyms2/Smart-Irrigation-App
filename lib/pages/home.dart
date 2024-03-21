// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import '../function/data.dart';
import '../features/sensor.dart';
import '../style/icons.dart';
import 'dart:async';

const celsiusSymbol = '\u{2103}';

class HomePage extends StatefulWidget {
  final SensorData sensorData = SensorData();

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.sensorData.fetchAllSensorData();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Irrigation System'),
        backgroundColor: const Color.fromARGB(255, 90, 180, 254),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SensorBox<TemperatureModel>(
                iconData: CustomIcons.thermometerIcon(),
              ),
              SensorBox<HumidityModel>(iconData: CustomIcons.humidityIcon()),
              SensorBox<SoilMoistureModel>(
                iconData: CustomIcons.soilMoistureIcon(),
              ),
              SensorBox<WaterLevelModel>(
                  iconData: CustomIcons.waterLevelIcon()),
              SensorBox<WaterPumpModel>(iconData: CustomIcons.waterPumpIcon()),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorBox<T> extends StatelessWidget {
  SensorBox({super.key, required this.iconData});
  final Widget iconData;
  final SensorData sensorData = SensorData();

  @override
  Widget build(BuildContext context) {
    Future<T?> fetchSensorData() async {
      try {
        if (T == TemperatureModel) {
          String? temperatureString = await sensorData.fetchTemperatureData();
          if (temperatureString != null) {
            double temperature = double.parse(temperatureString);
            return TemperatureModel(temperature: temperature) as T;
          } else {
            return null;
          }
        } else if (T == HumidityModel) {
          String? humidityString = await sensorData.fetchHumidityData();
          if (humidityString != null) {
            double humidity = double.parse(humidityString);
            return HumidityModel(humidity: humidity) as T;
          } else {
            return null;
          }
        } else if (T == SoilMoistureModel) {
          String? moistureString = await sensorData.fetchSoilMoistureData();
          if (moistureString != null) {
            String moisture = moistureString;
            return SoilMoistureModel(moisture: moisture) as T;
          } else {
            return null;
          }
        } else if (T == WaterLevelModel) {
          String? waterLevelString = await sensorData.fetchWaterLevelData();
          if (waterLevelString != null) {
            int waterLevel = int.parse(waterLevelString);
            return WaterLevelModel(waterLevel: waterLevel) as T;
          } else {
            return null;
          }
        } else if (T == WaterPumpModel) {
          String? waterPumpString = await sensorData.fetchWaterPumpData();
          if (waterPumpString != null) {
            int waterPump = int.parse(waterPumpString);
            return WaterPumpModel(waterPump: waterPump) as T;
          } else {
            return null;
          }
        } else {
          throw Exception('Unknown sensor type');
        }
      } catch (error) {
        logger.e('Error fetching sensor data: $error');
        return null;
      }
    }

    return FutureBuilder<T?>(
      future: fetchSensorData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 250.0,
            height: 120.0,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                iconData,
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getSensorTypeName(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getValueFromModel(snapshot.data!),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('Loading sensor data...');
        }
      },
    );
  }

  String getSensorTypeName() {
    if (T == TemperatureModel) {
      return 'Temperature';
    } else if (T == HumidityModel) {
      return 'Humidity';
    } else if (T == SoilMoistureModel) {
      return 'Soil Status';
    } else if (T == WaterLevelModel) {
      return 'Water Level';
    } else if (T == WaterPumpModel) {
      return 'Water Pump';
    } else {
      return 'Unknown Sensor';
    }
  }

  String getValueFromModel(dynamic model) {
    if (model is TemperatureModel) {
      return '${model.temperature.toString()}$celsiusSymbol';
    } else if (model is HumidityModel) {
      return '${model.humidity.toString()}%';
    } else if (model is SoilMoistureModel) {
      return model.moisture.toString();
    } else if (model is WaterLevelModel) {
      return '${model.waterLevel.toString()}%';
    } else if (model is WaterPumpModel) {
      if (model.waterPump.toString() == "1") {
        return 'On';
      } else {
        return 'Off';
      }
    } else {
      return 'Unknown value';
    }
  }
}
