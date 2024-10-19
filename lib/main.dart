import 'package:employees/injection_container.dart';
import 'package:employees/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalDI.setupFeaturesDI();

  runApp(const App());
}
