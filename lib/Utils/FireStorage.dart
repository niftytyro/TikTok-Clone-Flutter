import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List> getSoundUrls() async {
    return [
      await _firebaseStorage
          .ref()
          .child('sounds/Banana - Conkarah.mp3')
          .getDownloadURL()
    ];
  }
}

final FireStorage fireStorage = FireStorage();
