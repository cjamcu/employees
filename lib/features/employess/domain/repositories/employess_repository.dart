import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';

abstract class EmployeesRepository {
  Future<EmployeeData> getEmployees({required int page, required int limit});
  Future<EmployeeData> getEmployeesWithFilter(Map<String, dynamic> filters);
  Future<void> addEmployee(Employee employee);
  Future<bool> isEmailInUse(String email);
  Future<void> deleteEmployee(String employeeId);
}
