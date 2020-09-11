import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';

class FireAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String docID;

  Future<void> signIn() async {
    final GoogleSignInAccount _account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await _account.authentication;

    final AuthCredential _credentials = GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    final User user = (await _auth.signInWithCredential(_credentials)).user;
    docID = await fireDB.addUser(username: user.displayName, email: user.email);
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    docID = null;
  }

  User get getCurrentUser {
    return _auth.currentUser;
  }

  String get getDocID {
    return docID;
  }

  bool get isSignedIn {
    return _auth.currentUser == null ? false : true;
  }
}

final auth = FireAuth();
