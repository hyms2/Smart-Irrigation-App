import 'package:flutter/material.dart';

class CustomIcons {
  static Widget humidityIcon({double size = 40.0}) {
    return Image.asset(
      'assets/icons/icons8-humidity.png',
      width: size,
      height: size,
    );
  }

  static Widget soilMoistureIcon({double size = 40.0}) {
    return Image.asset(
      'assets/icons/icons8-soil.png',
      width: size,
      height: size,
    );
  }

  static Widget thermometerIcon({double size = 40.0}) {
    return Image.asset(
      'assets/icons/icons8-temperature.png',
      width: size,
      height: size,
    );
  }

  static Widget waterLevelIcon({double size = 40.0}) {
    return Image.asset(
      'assets/icons/icons8-aquarius.png',
      width: size,
      height: size,
    );
  }

  static Widget waterPumpIcon({double size = 40.0}) {
    return Image.asset(
      'assets/icons/icons8-water-hose.png',
      width: size,
      height: size,
    );
  }
}
