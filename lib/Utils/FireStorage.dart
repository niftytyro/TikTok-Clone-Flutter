import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> getSoundUrl({String path}) async {
    return await _firebaseStorage.ref().child(path).getDownloadURL();
  }
}

final FireStorage fireStorage = FireStorage();
