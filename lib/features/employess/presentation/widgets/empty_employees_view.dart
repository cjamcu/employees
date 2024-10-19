import 'package:flutter/material.dart';

class EmptyEmployeesView extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyEmployeesView({
    super.key,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No se encontraron empleados.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
