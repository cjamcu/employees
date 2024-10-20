import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employees/features/employess/presentation/bloc/form/employee_form_bloc.dart';
import 'package:employees/features/employess/presentation/widgets/custom_text_field.dart';
import 'package:employees/features/employess/presentation/widgets/custom_dropdown.dart';
import 'package:employees/features/employess/presentation/widgets/custom_date_picker.dart';
import 'package:employees/features/employess/presentation/widgets/photo_section.dart';
import 'package:employees/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:employees/features/employess/domain/validators/employee_validators.dart';

class EmployeeFormScreen extends StatelessWidget {
  EmployeeFormScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _firstSurnameController = TextEditingController();
  final _secondSurnameController = TextEditingController();
  final _idNumberController = TextEditingController();
  late final AppLocalizations l10n;
  late final EmployeeValidators _validators;

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    _validators = EmployeeValidators(l10n);
    return BlocProvider.value(
      value: getIt<EmployeeFormBloc>(),
      child: BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
        listener: (context, state) => _handleStateChanges(context, state),
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.newEmployee)),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: _buildPhotoSection(context, state)),
                      const SizedBox(height: 16),
                      _buildFormFields(context, state),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        isLoading: state is EmployeeFormSubmitting,
                        text: l10n.registerEmployee,
                        loadingText: l10n.registeringEmployee,
                        onPressed: () => _submitForm(context, state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, EmployeeFormState state) {
    if (state is ImageUploadFailure) {
      _showSnackBar(context, l10n.photoUploadError, Colors.red);
    } else if (state is EmployeeFormSubmissionSuccess) {
      _showSnackBar(context, l10n.employeeRegisteredSuccess, Colors.green);
      Navigator.of(context).pop(state.employee);
    } else if (state is EmployeeFormSubmissionFailure) {
      _showSnackBar(context, l10n.employeeRegistrationError, Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(message)),
    );
  }

  Widget _buildPhotoSection(BuildContext context, EmployeeFormState state) {
    return PhotoSection(
      photoFile: state.data?.photoFile,
      onTakePhoto: () => _takePhoto(context),
      onRemovePhoto: () =>
          context.read<EmployeeFormBloc>().add(const PhotoRemoved()),
      label: l10n.takePhoto,
    );
  }

  Widget _buildFormFields(BuildContext context, EmployeeFormState state) {
    return Column(
      children: [
        CustomTextField(
          controller: _firstNameController,
          label: l10n.firstName,
          validator: _validators.validateName,
        ),
        CustomTextField(
          controller: _otherNamesController,
          label: l10n.otherNames,
          validator: _validators.validateOtherNames,
        ),
        CustomTextField(
          controller: _firstSurnameController,
          label: l10n.firstSurname,
          validator: _validators.validateName,
        ),
        CustomTextField(
          controller: _secondSurnameController,
          label: l10n.secondSurname,
          validator: _validators.validateName,
        ),
        CustomDropdown(
          label: l10n.employmentCountry,
          value: state.data?.employmentCountry,
          items: {
            'CO': l10n.colombia,
            'US': l10n.unitedStates,
            'VE': l10n.venezuela
          },
          onChanged: (value) => context
              .read<EmployeeFormBloc>()
              .add(EmploymentCountryChanged(value)),
        ),
        CustomDropdown(
          label: l10n.idType,
          value: state.data?.idType,
          items: {
            0: l10n.citizenshipCard,
            1: l10n.foreignerID,
            2: l10n.passport,
            3: l10n.specialPermit
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(IdTypeChanged(value)),
        ),
        CustomTextField(
          controller: _idNumberController,
          label: l10n.idNumber,
          validator: _validators.validateIdNumber,
        ),
        CustomDatePicker(
          selectedDate: state.data?.entryDate,
          onDateChanged: (date) =>
              context.read<EmployeeFormBloc>().add(EntryDateChanged(date)),
          label: l10n.entryDate,
          selectDateText: l10n.selectDate,
        ),
        CustomDropdown(
          label: l10n.area,
          value: state.data?.area,
          items: {
            0: l10n.administration,
            1: l10n.finance,
            2: l10n.purchasing,
            3: l10n.infrastructure,
            4: l10n.operations,
            5: l10n.humanResources,
            6: l10n.variousServices
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(AreaChanged(value)),
        ),
      ],
    );
  }

  void _takePhoto(BuildContext context) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      context.read<EmployeeFormBloc>().add(PhotoTaken(File(image.path)));
    }
  }

  void _submitForm(BuildContext context, EmployeeFormState state) {
    if (_formKey.currentState!.validate() &&
        state.data?.entryDate != null &&
        state.data?.photoFile != null) {
      context.read<EmployeeFormBloc>().add(SubmitForm(
            firstName: _firstNameController.text,
            firstSurname: _firstSurnameController.text,
            secondSurname: _secondSurnameController.text,
            otherNames: _otherNamesController.text,
            idNumber: _idNumberController.text,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseCompleteAllFields)),
      );
    }
  }
}
