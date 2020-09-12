import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  FireStorage() {
    _ref = _firebaseStorage.ref();
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _ref;

  Future<String> getDownloadUrl({String path}) async {
    String url = '';
    try {
      url = await _ref.child(path).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return url;
  }

  Future<List> uploadFile(File file, String id) async {
    DateTime timestamp = DateTime.now().toUtc();
    String filePath = 'uploads/${id}_$timestamp.mp4';
    StorageUploadTask _uploadTask = _ref.child(filePath).putFile(file);
    await _uploadTask.onComplete;
    return [filePath, timestamp];
  }
}

final FireStorage fireStorage = FireStorage();
