import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/presentation/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'employee_card.dart';

class EmployeeList extends StatefulWidget {
  final VoidCallback onLoadMore;
  final Function(Employee) onDelete;
  final EmployeeData employeeData;
  final bool isLoadingMore;

  const EmployeeList({
    super.key,
    required this.onLoadMore,
    required this.onDelete,
    required this.employeeData,
    required this.isLoadingMore,
  });

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeData = widget.employeeData;

    return ListView.builder(
      controller: _scrollController,
      itemCount: employeeData.employees.length + 1,
      itemBuilder: (context, index) {
        if (index == employeeData.employees.length) {
          return _buildLoadingIndicator();
        }
        final employee = employeeData.employees[index];
        return EmployeeCard(
          employee: employee,
          onDelete: widget.onDelete,
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    if (widget.isLoadingMore) {
      return const LoadingView(message: 'Cargando más empleados...');
    } else {
      return const SizedBox.shrink();
    }
  }
}
