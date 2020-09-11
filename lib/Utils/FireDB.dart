import 'package:cloud_firestore/cloud_firestore.dart';

class FireDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addUser({String username, String email}) async {
    String id;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.size == 0) {
      id = (await _firestore.collection('users').add({
        'username': username,
        'email': email,
      }))
          .id;
    } else {
      id = snapshot.docs.first.id;
    }
    return id;
  }

  Stream<QuerySnapshot> getSoundsStream() {
    return _firestore.collection('sounds').snapshots();
  }
}

final fireDB = FireDB();
