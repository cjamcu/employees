import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employees/features/employess/presentation/bloc/form/employee_form_bloc.dart';
import 'package:employees/features/employess/presentation/widgets/custom_text_field.dart';
import 'package:employees/features/employess/presentation/widgets/custom_dropdown.dart';
import 'package:employees/features/employess/presentation/widgets/custom_date_picker.dart';
import 'package:employees/features/employess/presentation/widgets/photo_section.dart';

import 'dart:io';

class EmployeeFormScreen extends StatefulWidget {
  EmployeeFormScreen({super.key});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _otherNamesController = TextEditingController();

  final _firstSurnameController = TextEditingController();

  final _secondSurnameController = TextEditingController();

  final _idNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _otherNamesController.dispose();
    _firstSurnameController.dispose();
    _secondSurnameController.dispose();
    _idNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EmployeeFormBloc>(),
      child: BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nuevo Empleado')),
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
                        text: 'Registrar Empleado',
                        loadingText: 'Registrando...',
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
      _showSnackBar(context,
          'Ocurrió un error al subir la foto. Intenta nuevamente.', Colors.red);
    } else if (state is EmployeeFormSubmissionSuccess) {
      _showSnackBar(context, 'Empleado registrado con éxito', Colors.green);
      Navigator.of(context).pop(state.employee);
    } else if (state is EmployeeFormSubmissionFailure) {
      _showSnackBar(
          context,
          'Ocurrió un error al registrar el empleado. Intenta nuevamente.',
          Colors.red);
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
    );
  }

  Widget _buildFormFields(BuildContext context, EmployeeFormState state) {
    return Column(
      children: [
        CustomTextField(
          controller: _firstNameController,
          label: 'Primer Nombre',
          validator: _validateName,
        ),
        CustomTextField(
          controller: _otherNamesController,
          label: 'Otros Nombres',
          validator: _validateOtherNames,
        ),
        CustomTextField(
          controller: _firstSurnameController,
          label: 'Primer Apellido',
          validator: _validateName,
        ),
        CustomTextField(
          controller: _secondSurnameController,
          label: 'Segundo Apellido',
          validator: _validateName,
        ),
        CustomDropdown(
          label: 'País del empleo',
          value: state.data?.employmentCountry,
          items: {'CO': 'Colombia', 'US': 'Estados Unidos'},
          onChanged: (value) => context
              .read<EmployeeFormBloc>()
              .add(EmploymentCountryChanged(value)),
        ),
        CustomDropdown(
          label: 'Tipo de Identificación',
          value: state.data?.idType,
          items: {
            0: 'Cédula de Ciudadanía',
            1: 'Cédula de Extranjería',
            2: 'Pasaporte',
            3: 'Permiso Especial'
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(IdTypeChanged(value)),
        ),
        CustomTextField(
          controller: _idNumberController,
          label: 'Número de Identificación',
          validator: _validateIdNumber,
        ),
        CustomDatePicker(
          selectedDate: state.data?.entryDate,
          onDateChanged: (date) =>
              context.read<EmployeeFormBloc>().add(EntryDateChanged(date)),
        ),
        CustomDropdown(
          label: 'Área',
          value: state.data?.area,
          items: {
            0: 'Administración',
            1: 'Financiera',
            2: 'Compras',
            3: 'Infraestructura',
            4: 'Operación',
            5: 'Talento Humano',
            6: 'Servicios Varios'
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(AreaChanged(value)),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, EmployeeFormState state) {
    return ElevatedButton(
      onPressed: state is EmployeeFormSubmitting
          ? null
          : () => _submitForm(context, state),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: state is EmployeeFormSubmitting
          ? const CircularProgressIndicator()
          : const Text('Registrar Empleado'),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.length > 20) {
      return 'Máximo 20 caracteres';
    }
    if (!RegExp(r'^[A-Z]+$').hasMatch(value)) {
      return 'Solo letras mayúsculas sin acentos ni Ñ';
    }
    return null;
  }

  String? _validateOtherNames(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 50) {
      return 'Máximo 50 caracteres';
    }
    if (!RegExp(r'^[A-Z ]+$').hasMatch(value)) {
      return 'Solo letras mayúsculas sin acentos ni Ñ y espacios';
    }
    return null;
  }

  String? _validateIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.length > 20) {
      return 'Máximo 20 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
      return 'Solo letras, números y guiones';
    }
    return null;
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
        const SnackBar(
            content:
                Text('Por favor, complete todos los campos y tome una foto')),
      );
    }
  }
}
