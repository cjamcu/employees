import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employees/features/employess/presentation/bloc/list/employees_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeFilterBottomSheet extends StatelessWidget {
  const EmployeeFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Text(l10n.filterEmployees,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  _buildFilterTextField(l10n.firstName, state.filter.firstName,
                      (value) => _updateFilter(context, firstName: value)),
                  _buildFilterTextField(
                      l10n.otherNames,
                      state.filter.otherNames,
                      (value) => _updateFilter(context, otherNames: value)),
                  _buildFilterTextField(
                      l10n.firstSurname,
                      state.filter.firstSurname,
                      (value) => _updateFilter(context, firstSurname: value)),
                  _buildFilterTextField(
                      l10n.secondSurname,
                      state.filter.secondSurname,
                      (value) => _updateFilter(context, secondSurname: value)),
                  _buildFilterDropdown(
                      l10n.idType,
                      state.filter.idType,
                      state.idTypes,
                      (value) => _updateFilter(context, idType: value)),
                  _buildFilterTextField(l10n.idNumber, state.filter.idNumber,
                      (value) => _updateFilter(context, idNumber: value)),
                  _buildFilterDropdown(
                      l10n.employmentCountry,
                      state.filter.employmentCountry,
                      state.countries,
                      (value) =>
                          _updateFilter(context, employmentCountry: value)),
                  _buildFilterTextField(l10n.email, state.filter.email,
                      (value) => _updateFilter(context, email: value)),
                  _buildFilterDropdown(
                      l10n.status,
                      state.filter.isActive,
                      {'true': l10n.active, 'false': l10n.inactive},
                      (value) =>
                          _updateFilter(context, isActive: value == 'true')),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: l10n.applyFilters,
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
                    child: Text(l10n.resetFilters),
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
