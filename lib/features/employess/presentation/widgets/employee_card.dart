import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                Text('País: ${employee.countryHumanReadable}'),
                Text('Área: ${employee.areaHumanReadable}'),
                Text(
                    'Fecha de ingreso: ${DateFormat('dd/MM/yyyy').format(employee.entryDate)}'),
                Text('Estado: ${employee.isActive ? 'Activo' : 'Inactivo'}'),
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
                        _showDeleteConfirmationDialog(context, employee);
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

  void _showDeleteConfirmationDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Está seguro de que desea eliminar al empleado ${employee.firstName} ${employee.firstSurname}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                onDelete(employee);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
