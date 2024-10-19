part of 'employee_form_bloc.dart';

class EmployeeFormState extends Equatable {
  final Data? data;

  const EmployeeFormState({this.data});

  @override
  List<Object?> get props => [data];
}

class EmployeeFormInitial extends EmployeeFormState {
  const EmployeeFormInitial() : super(data: const Data());
}

class EmployeeFormSubmitting extends EmployeeFormState {
  const EmployeeFormSubmitting({required super.data});
}

class EmployeeFormSubmissionSuccess extends EmployeeFormState {
  final Employee employee;
  const EmployeeFormSubmissionSuccess(
      {required super.data, required this.employee});
}

class EmployeeFormSubmissionFailure extends EmployeeFormState {
  const EmployeeFormSubmissionFailure({required super.data});

  @override
  List<Object> get props => [];
}

class ImageUploading extends EmployeeFormState {
  const ImageUploading({required super.data});
}

class ImageUploadSuccess extends EmployeeFormState {
  final String imageUrl;

  const ImageUploadSuccess({required this.imageUrl, required super.data});

  @override
  List<Object> get props => [imageUrl];
}

class ImageUploadFailure extends EmployeeFormState {
  const ImageUploadFailure({required super.data});

  @override
  List<Object> get props => [];
}

class DataUpdatedState extends EmployeeFormState {
  const DataUpdatedState({required super.data});
}

class Data extends Equatable {
  final String? employmentCountry;
  final int? idType;
  final int? area;
  final DateTime? entryDate;
  final File? photoFile;

  const Data({
    this.employmentCountry,
    this.idType,
    this.area,
    this.entryDate,
    this.photoFile,
  });

  Data copyWith({
    String? employmentCountry,
    int? idType,
    int? area,
    DateTime? entryDate,
    File? photoFile,
  }) {
    return Data(
      employmentCountry: employmentCountry ?? this.employmentCountry,
      idType: idType ?? this.idType,
      area: area ?? this.area,
      entryDate: entryDate ?? this.entryDate,
      photoFile: photoFile ?? this.photoFile,
    );
  }

  Data copyWithRemovePhoto() {
    return Data(
      employmentCountry: employmentCountry,
      idType: idType,
      area: area,
      entryDate: entryDate,
      photoFile: null,
    );
  }

  @override
  List<Object?> get props => [
        employmentCountry,
        idType,
        area,
        entryDate,
        photoFile,
      ];
}
