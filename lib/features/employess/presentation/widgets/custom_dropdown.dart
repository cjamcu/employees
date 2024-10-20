import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final dynamic value;
  final Map<dynamic, String> items;
  final Function(dynamic) onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: items.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Campo requerido' : null,
      ),
    );
  }
}
