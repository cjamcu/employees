import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/repositories/employess_repository.dart';
import '../../../domain/repositories/file_upload_repository.dart';
import 'dart:io';

part 'employee_form_event.dart';
part 'employee_form_state.dart';

class EmployeeFormBloc extends Bloc<EmployeeFormEvent, EmployeeFormState> {
  final EmployeesRepository employeesRepository;
  final FilesRepository fileUploadRepository;

  EmployeeFormBloc({
    required this.employeesRepository,
    required this.fileUploadRepository,
  }) : super(const EmployeeFormInitial()) {
    on<EmploymentCountryChanged>(_onEmploymentCountryChanged);
    on<IdTypeChanged>(_onIdTypeChanged);
    on<AreaChanged>(_onAreaChanged);
    on<EntryDateChanged>(_onEntryDateChanged);
    on<PhotoTaken>(_onPhotoTaken);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<SubmitForm>(_onSubmitForm);
  }

  void _onEmploymentCountryChanged(
      EmploymentCountryChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(
        data: state.data?.copyWith(employmentCountry: event.country)));
  }

  void _onIdTypeChanged(IdTypeChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(idType: event.idType)));
  }

  void _onAreaChanged(AreaChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(area: event.area)));
  }

  void _onEntryDateChanged(
      EntryDateChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(entryDate: event.date)));
  }

  void _onPhotoTaken(PhotoTaken event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(
        data: state.data?.copyWith(photoFile: event.photoFile)));
  }

  void _onPhotoRemoved(PhotoRemoved event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWithRemovePhoto()));
  }

  void _onSubmitForm(SubmitForm event, Emitter<EmployeeFormState> emit) async {
    emit(EmployeeFormSubmitting(data: state.data));
    try {
      final email = await _generateUniqueEmail(
        event.firstName,
        event.firstSurname,
        state.data!.employmentCountry!,
      );

      String photoUrl = '';

      try {
        photoUrl =
            await fileUploadRepository.uploadImage(state.data!.photoFile!);
      } catch (e) {
        emit(ImageUploadFailure(data: state.data));
        return;
      }

      final employee = Employee(
        id: _generateUniqueId(),
        firstName: event.firstName,
        otherNames: event.otherNames,
        employmentCountry: state.data!.employmentCountry!,
        registrationDate: DateTime.now(),
        isActive: true,
        firstSurname: event.firstSurname,
        secondSurname: event.secondSurname,
        email: email,
        photoUrl: photoUrl,
        idType: state.data!.idType!,
        idNumber: event.idNumber,
        entryDate: state.data!.entryDate!,
        area: state.data!.area!,
      );

      await employeesRepository.addEmployee(employee);
      emit(EmployeeFormSubmissionSuccess(data: state.data, employee: employee));
    } catch (e) {
      emit(EmployeeFormSubmissionFailure(data: state.data));
    }
  }

  Future<String> _generateUniqueEmail(
    String firstName,
    String firstSurname,
    String employmentCountry,
  ) async {
    final baseEmail =
        '${firstName.toLowerCase()}.${firstSurname.toLowerCase()}';
    final domain =
        employmentCountry == 'CO' ? 'tuarmi.com.co' : 'armirene.com.ve';

    var email = '$baseEmail@$domain';
    var counter = 1;

    while (await employeesRepository.isEmailInUse(email)) {
      email = '$baseEmail.$counter@$domain';
      counter++;
    }

    return email;
  }

  // Generate a unique id for the employee
  String _generateUniqueId() {
    return const Uuid().v4();
  }
}
