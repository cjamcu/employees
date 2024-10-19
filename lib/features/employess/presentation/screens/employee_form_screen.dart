import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/form/employee_form_bloc.dart';

import 'dart:io';

class EmployeeFormScreen extends StatelessWidget {
  EmployeeFormScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _firstSurnameController = TextEditingController();
  final _secondSurnameController = TextEditingController();
  final _idNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EmployeeFormBloc>(),
      child: BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
        listener: (context, state) {
          if (state is ImageUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                    'Ocurrió un error al subir la foto. Intenta nuevamente.'),
              ),
            );
          } else if (state is EmployeeFormSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Empleado registrado con éxito'),
              ),
            );
            Navigator.of(context).pop(state.employee);
          } else if (state is EmployeeFormSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                    'Ocurrió un error al registrar el empleado. Intenta nuevamente.'),
              ),
            );
          }
        },
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
                      const SizedBox(height: 24),
                      _buildTextField(
                          _firstNameController, 'Primer Nombre', _validateName),
                      _buildTextField(_otherNamesController, 'Otros Nombres',
                          _validateOtherNames),
                      _buildTextField(_firstSurnameController,
                          'Primer Apellido', _validateName),
                      _buildTextField(_secondSurnameController,
                          'Segundo Apellido', _validateName),
                      _buildDropdown(
                        context,
                        'País del empleo',
                        state.data?.employmentCountry,
                        {'CO': 'Colombia', 'US': 'Estados Unidos'},
                        (value) => context
                            .read<EmployeeFormBloc>()
                            .add(EmploymentCountryChanged(value)),
                      ),
                      _buildDropdown(
                        context,
                        'Tipo de Identificación',
                        state.data?.idType,
                        {
                          0: 'Cédula de Ciudadanía',
                          1: 'Cédula de Extranjería',
                          2: 'Pasaporte',
                          3: 'Permiso Especial'
                        },
                        (value) => context
                            .read<EmployeeFormBloc>()
                            .add(IdTypeChanged(value)),
                      ),
                      _buildTextField(_idNumberController,
                          'Número de Identificación', _validateIdNumber),
                      _buildDatePicker(context, state),
                      _buildDropdown(
                        context,
                        'Área',
                        state.data?.area,
                        {
                          0: 'Administración',
                          1: 'Financiera',
                          2: 'Compras',
                          3: 'Infraestructura',
                          4: 'Operación',
                          5: 'Talento Humano',
                          6: 'Servicios Varios'
                        },
                        (value) => context
                            .read<EmployeeFormBloc>()
                            .add(AreaChanged(value)),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state is EmployeeFormSubmitting
                            ? null
                            : () => _submitForm(context, state),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is EmployeeFormSubmitting
                            ? const CircularProgressIndicator()
                            : const Text('Registrar Empleado'),
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

  Widget _buildPhotoSection(BuildContext context, EmployeeFormState state) {
    return GestureDetector(
      onTap: () => _takePhoto(context),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: state.data?.photoFile != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        Image.file(state.data!.photoFile!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => context
                          .read<EmployeeFormBloc>()
                          .add(const PhotoRemoved()),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 20, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Tomar foto', style: TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String label, dynamic value,
      Map<dynamic, String> items, Function(dynamic) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
        validator: (value) => value == null ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, EmployeeFormState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            context.read<EmployeeFormBloc>().add(EntryDateChanged(date));
          }
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Fecha de ingreso',
            border: OutlineInputBorder(),
          ),
          child: Text(
            state.data?.entryDate == null
                ? 'Seleccionar fecha'
                : '${state.data!.entryDate!.day}/${state.data!.entryDate!.month}/${state.data!.entryDate!.year}',
          ),
        ),
      ),
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
