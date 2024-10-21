import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class OnlyLettersTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll(RegExp(r'[^A-Z]'), ''),
      selection: newValue.selection,
    );
  }
}

// Identificación: Es el número de identificación del empleado, debe ser
// alfanumérico permitiendo los siguientes conjuntos de caracteres (a-z / AZ / 0-9 / -). No
// podrán existir dos empleados con el mismo número y tipo de identificación. Su longitud
// máxima serán 20 caracteres.

class IdentificationTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), ''),
      selection: newValue.selection,
    );
  }
}
