import 'package:employees/features/employess/presentation/screens/employee_form_screen.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/list/employees_bloc.dart';
import '../widgets/employee_list.dart';
import '../widgets/employee_filter_bottom_sheet.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/empty_employees_view.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeesBloc>()..add(const LoadEmployees()),
      child: const EmployeesView(),
    );
  }
}

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: BlocConsumer<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeesDeletedFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Ocurrió un error al eliminar el empleado.'),
                ),
              );
            }

            if (state is EmployeesDeletedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Empleado eliminado correctamente.'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EmployeesError) {
              return ErrorView(
                onRetry: () =>
                    context.read<EmployeesBloc>().add(const LoadEmployees()),
              );
            }

            if (state is EmployeesLoading) {
              return const Center(
                  child: LoadingView(message: 'Cargando empleados...'));
            }

            if (state is EmployeesLoadedWithFilter &&
                state.employeeData.employees.isEmpty) {
              return EmptyEmployeesView(
                message:
                    'No se encontraron empleados con los filtros aplicados. Aplique otros filtros para encontrar empleados.',
                buttonText: 'Reestablecer filtros',
                onButtonPressed: () =>
                    context.read<EmployeesBloc>().add(ResetFilter()),
              );
            }

            if (state is EmployeesLoaded &&
                state.employeeData.employees.isEmpty) {
              return const EmptyEmployeesView(
                message:
                    'Agregue un nuevo empleado para comenzar. Presiona el botón más para agregar uno nuevo',
              );
            }

            if (state is EmployeesLoaded) {
              return EmployeeList(
                employeeData: state.employeeData,
                isLoadingMore: state is EmployeesLoadingMore,
                onLoadMore: () =>
                    context.read<EmployeesBloc>().add(LoadMoreEmployees()),
                onDelete: (employee) => context
                    .read<EmployeesBloc>()
                    .add(EmployeeDeleted(employee)),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final employee = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeFormScreen()),
          );

          if (employee != null) {
            context.read<EmployeesBloc>().add(EmployeeAdded(employee));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const EmployeeFilterBottomSheet(),
    );
  }
}
