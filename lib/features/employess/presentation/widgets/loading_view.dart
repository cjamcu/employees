import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 8),
          Text(message ?? 'Cargando...'),
        ],
      ),
    );
  }
}
