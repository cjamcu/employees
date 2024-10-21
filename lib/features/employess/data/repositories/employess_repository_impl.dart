import 'package:employees/features/employess/data/datasources/employess_datasource.dart';
import 'package:employees/features/employess/data/models/employee.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';

class EmployeesRepositoryImpl extends EmployeesRepository {
  final EmployeesDataSource employeesRemoteDataSource;
  EmployeesRepositoryImpl({
    required this.employeesRemoteDataSource,
  });

  @override
  Future<EmployeeData> getEmployees({int page = 1, int limit = 10}) async {
    return await employeesRemoteDataSource.getEmployees(
      page: page,
      limit: limit,
    );
  }

  @override
  Future<EmployeeData> getEmployeesWithFilter(
      Map<String, dynamic> filters) async {
    return await employeesRemoteDataSource.getEmployeesWithFilter(filters);
  }

  @override
  Future<void> addEmployee(Employee employee) async {
    return await employeesRemoteDataSource
        .addEmployee(EmployeeModel.fromEntity(employee));
  }

  @override
  Future<bool> isEmailInUse(String email) async {
    return await employeesRemoteDataSource.isEmailInUse(email);
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    await employeesRemoteDataSource.deleteEmployee(employeeId);
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    return await employeesRemoteDataSource
        .updateEmployee(EmployeeModel.fromEntity(employee));
  }

  @override
  Future<bool> isIdNumberInUse({
    required int idType,
    required String idNumber,
    required String? excludeEmployeeId,
  }) async {
    return await employeesRemoteDataSource.isIdNumberInUse(
      idType: idType,
      idNumber: idNumber,
      excludeEmployeeId: excludeEmployeeId,
    );
  }

  @override
  Future<void> generateFakeEmployees(List<Employee> employees) async {
    for (var employee in employees) {
      await employeesRemoteDataSource
          .addEmployee(EmployeeModel.fromEntity(employee));
    }
  }
}
