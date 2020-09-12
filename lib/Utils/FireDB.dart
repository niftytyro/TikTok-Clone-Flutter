import 'package:cloud_firestore/cloud_firestore.dart';

class FireDB {
  FireDB() {
    print('initializing FIRDBBBBBBBBBBBBBBBB--------------------------------');
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addUser({String username, String email}) async {
    String id;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.size == 0) {
      id = (await _firestore.collection('users').add({
        'name': username,
        'email': email,
        'username': '@' + email.substring(0, email.lastIndexOf('@')),
      }))
          .id;
    } else {
      id = snapshot.docs.first.id;
    }
    return id;
  }

  Future<void> addPost(
      {String creator,
      String path,
      String description,
      DateTime timestamp}) async {
    DocumentReference _docRef = await _firestore.collection('uploads').add({
      'creator': creator,
      'path': path,
      'description': description,
      'likes': 0,
      'timestamp': timestamp,
      'likedBy': [],
    });
    _docRef.collection('comments');
  }

  Stream<QuerySnapshot> getSoundsStream() {
    return _firestore.collection('sounds').snapshots();
  }

  Stream<QuerySnapshot> getUploadsStream() {
    return _firestore
        .collection('uploads')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getUsername(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(id).get();
    return snapshot.data()['username'];
  }
}

final fireDB = FireDB();
