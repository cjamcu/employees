import 'package:employees/features/employess/presentation/screens/employess_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employees',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14495D)),
        useMaterial3: true,
      ),
      home: const EmployeesScreen(),
    );
  }
}
