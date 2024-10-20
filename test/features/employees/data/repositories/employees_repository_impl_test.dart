import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employees/features/employess/data/datasources/employess_datasource.dart';
import 'package:employees/features/employess/data/repositories/employess_repository_impl.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/data/models/employee.dart';

class MockEmployeesDataSource extends Mock implements EmployeesDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(EmployeeModel(
      id: '1',
      firstName: 'John',
      firstSurname: 'Doe',
      secondSurname: 'Smith',
      email: 'john@example.com',
      employmentCountry: 'US',
      idType: 0,
      idNumber: '123456',
      entryDate: DateTime(2023, 1, 1),
      area: 0,
      registrationDate: DateTime(2023, 1, 1),
      photoUrl: 'http://example.com/photo.jpg',
    ));
  });

  late EmployeesRepositoryImpl repository;
  late MockEmployeesDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockEmployeesDataSource();
    repository =
        EmployeesRepositoryImpl(employeesRemoteDataSource: mockDataSource);
  });

  group('EmployeesRepositoryImpl', () {
    final tEmployee = Employee(
      id: '1',
      firstName: 'John',
      firstSurname: 'Doe',
      secondSurname: 'Smith',
      email: 'john@example.com',
      employmentCountry: 'US',
      idType: 0,
      idNumber: '123456',
      entryDate: DateTime(2023, 1, 1),
      area: 0,
      registrationDate: DateTime(2023, 1, 1),
      photoUrl: 'http://example.com/photo.jpg',
    );

    final tEmployeeData = EmployeeData(
      page: 1,
      totalPages: 1,
      employees: [tEmployee],
    );

    test('getEmployees should return EmployeeData from the data source',
        () async {
      when(() => mockDataSource.getEmployees(page: 1, limit: 10))
          .thenAnswer((_) async => tEmployeeData);

      final result = await repository.getEmployees(page: 1, limit: 10);

      expect(result, equals(tEmployeeData));
      verify(() => mockDataSource.getEmployees(page: 1, limit: 10)).called(1);
    });

    test(
        'getEmployeesWithFilter should return EmployeeData from the data source',
        () async {
      final filters = {'firstName': 'John'};
      when(() => mockDataSource.getEmployeesWithFilter(filters))
          .thenAnswer((_) async => tEmployeeData);

      final result = await repository.getEmployeesWithFilter(filters);

      expect(result, equals(tEmployeeData));
      verify(() => mockDataSource.getEmployeesWithFilter(filters)).called(1);
    });

    test('addEmployee should call the data source', () async {
      when(() => mockDataSource.addEmployee(any())).thenAnswer((_) async {});

      await repository.addEmployee(tEmployee);

      verify(() => mockDataSource.addEmployee(any())).called(1);
    });

    test('isEmailInUse should return boolean from the data source', () async {
      when(() => mockDataSource.isEmailInUse('john@example.com'))
          .thenAnswer((_) async => true);

      final result = await repository.isEmailInUse('john@example.com');

      expect(result, isTrue);
      verify(() => mockDataSource.isEmailInUse('john@example.com')).called(1);
    });

    test('deleteEmployee should call the data source', () async {
      when(() => mockDataSource.deleteEmployee('1')).thenAnswer((_) async {});

      await repository.deleteEmployee('1');

      verify(() => mockDataSource.deleteEmployee('1')).called(1);
    });
  });
}
