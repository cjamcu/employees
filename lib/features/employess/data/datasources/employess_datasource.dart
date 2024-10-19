import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:employees/features/employess/data/models/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';

abstract class EmployeesDataSource {
  Future<EmployeeData> getEmployees({required int page, required int limit});
  Future<EmployeeData> getEmployeesWithFilter(Map<String, dynamic> filters);
  Future<void> addEmployee(EmployeeModel employee);
  Future<bool> isEmailInUse(String email);
  Future<void> deleteEmployee(String employeeId);
}

class EmployeesDataSourceImpl implements EmployeesDataSource {
  final FirebaseFirestore _firestoreDb;

  EmployeesDataSourceImpl(this._firestoreDb);

  @override
  Future<EmployeeData> getEmployees({
    required int page,
    required int limit,
  }) async {
    final countSnapshot =
        await _firestoreDb.collection('employees').count().get();
    final totalEmployees = countSnapshot.count ?? 0;
    final totalPages = (totalEmployees / limit).ceil();

    if (page > totalPages || page < 1) {
      throw Exception('The page requested is not valid.');
    }

    Query query = _firestoreDb.collection('employees').limit(limit);
    if (page > 1) {
      final startAfterSnapshot = await _firestoreDb
          .collection('employees')
          .limit((page - 1) * limit)
          .get();

      final lastDoc = startAfterSnapshot.docs.last;
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();

    final employees = snapshot.docs
        .map((doc) =>
            EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return EmployeeData(
      page: page,
      totalPages: totalPages,
      employees: employees,
    );
  }

  @override
  Future<EmployeeData> getEmployeesWithFilter(
      Map<String, dynamic> filters) async {
    Query query = _firestoreDb.collection('employees');

    filters.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });

    final snapshot = await query.get();

    final employees = snapshot.docs
        .map((doc) =>
            EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return EmployeeData(
      page: 1,
      totalPages: 1,
      employees: employees,
    );
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    await _firestoreDb.collection('employees').add(employee.toJson());
  }

  @override
  Future<bool> isEmailInUse(String email) async {
    final result = await _firestoreDb
        .collection('employees')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    await _firestoreDb.collection('employees').doc(employeeId).delete();
  }
}
