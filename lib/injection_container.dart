import 'package:employees/features/employess/employess_di.dart';

class GlobalDI {
  static Future<void> setupFeaturesDI() async {
    final features = [
      EmployeesDI(),
    ];
    for (final feature in features) {
      await feature.setup();
    }
  }
}
