import 'dart:io';
import 'package:employees/features/employess/data/datasources/file_upload_datasource.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDataSourceImpl implements FilesDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSourceImpl(this._storage);

  @override
  Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('employee_photos/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
