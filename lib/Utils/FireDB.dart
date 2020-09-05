import 'package:cloud_firestore/cloud_firestore.dart';

class FireDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser({String username, String email}) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.size == 0) {
      _firestore.collection('users').add({
        username: username,
        email: email,
      });
    }
  }
}

final fireDB = FireDB();
