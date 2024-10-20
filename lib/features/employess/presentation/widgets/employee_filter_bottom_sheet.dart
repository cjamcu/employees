import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/list/employees_bloc.dart';

class EmployeeFilterBottomSheet extends StatelessWidget {
  const EmployeeFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EmployeesBloc>(),
      child: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Filtrar empleados',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  _buildFilterTextField('Primer nombre', state.filter.firstName,
                      (value) => _updateFilter(context, firstName: value)),
                  _buildFilterTextField(
                      'Segundo nombre',
                      state.filter.otherNames,
                      (value) => _updateFilter(context, otherNames: value)),
                  _buildFilterTextField(
                      'Primer apellido',
                      state.filter.firstSurname,
                      (value) => _updateFilter(context, firstSurname: value)),
                  _buildFilterTextField(
                      'Segundo apellido',
                      state.filter.secondSurname,
                      (value) => _updateFilter(context, secondSurname: value)),
                  _buildFilterDropdown(
                      'Tipo de documento',
                      state.filter.idType,
                      state.idTypes,
                      (value) => _updateFilter(context, idType: value)),
                  _buildFilterTextField(
                      'Número de cédula',
                      state.filter.idNumber,
                      (value) => _updateFilter(context, idNumber: value)),
                  _buildFilterDropdown(
                      'País de empleo',
                      state.filter.employmentCountry,
                      state.countries,
                      (value) =>
                          _updateFilter(context, employmentCountry: value)),
                  _buildFilterTextField(
                      'Correo electrónico',
                      state.filter.email,
                      (value) => _updateFilter(context, email: value)),
                  _buildFilterDropdown(
                      'Estado',
                      state.filter.isActive,
                      {'true': 'Activo', 'false': 'Inactivo'},
                      (value) =>
                          _updateFilter(context, isActive: value == 'true')),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Aplicar filtros',
                      isLoading: state is EmployeesLoading,
                      onPressed: () {
                        context.read<EmployeesBloc>().add(ApplyFilter());
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<EmployeesBloc>().add(ResetFilter());
                      Navigator.pop(context);
                    },
                    child: const Text('Reestablecer filtros'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTextField(
      String label, String? value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFilterDropdown(String label, dynamic value,
      Map<dynamic, String> items, Function(dynamic) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
      ),
    );
  }

  void _updateFilter(
    BuildContext context, {
    String? firstName,
    String? otherNames,
    String? firstSurname,
    String? secondSurname,
    int? idType,
    String? idNumber,
    String? employmentCountry,
    String? email,
    bool? isActive,
  }) {
    final currentState = context.read<EmployeesBloc>().state;
    context.read<EmployeesBloc>().add(UpdateFilter(
          currentState.filter.copyWith(
            firstName: firstName,
            otherNames: otherNames,
            firstSurname: firstSurname,
            secondSurname: secondSurname,
            idType: idType,
            idNumber: idNumber,
            employmentCountry: employmentCountry,
            email: email,
            isActive: isActive,
          ),
        ));
  }
}
