import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  FireStorage() {
    _ref = _firebaseStorage.ref();
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _ref;

  Future<String> getSoundUrl({String path}) async {
    return await _ref.child(path).getDownloadURL();
  }

  Future<List> uploadFile(File file, String id) async {
    DateTime timestamp = DateTime.now().toUtc();
    String filePath = 'uploads/${id}_$timestamp.mp4';
    _ref.child(filePath).putFile(file);
    return [filePath, timestamp];
  }
}

final FireStorage fireStorage = FireStorage();
