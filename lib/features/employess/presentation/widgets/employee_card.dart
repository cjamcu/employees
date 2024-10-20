import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final Function(Employee) onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(employee.photoUrl),
        ),
        title: Text(employee.fullName),
        subtitle: Text(employee.email),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${employee.idTypeHumanReadable}: ${employee.idNumber}'),
                Text('${l10n.country}: ${employee.countryHumanReadable}'),
                Text('${l10n.area}: ${employee.areaHumanReadable}'),
                Text(
                    '${l10n.entryDate}: ${DateFormat('dd/MM/yyyy').format(employee.entryDate)}'),
                Text('${l10n.status}: ${employee.isActive ? l10n.active : l10n.inactive}'),
                const SizedBox(height: 8),
                Row(  
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implementar la edición del empleado
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onDelete(employee);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
