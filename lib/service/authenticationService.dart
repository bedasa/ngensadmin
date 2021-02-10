import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:ngens/models/user.dart';
import '../constants.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
RUser currentUser;

class AuthenticationService {
  FirebaseAuth _firebaseAuth;
  AuthenticationService() {
    _firebaseAuth = FirebaseAuth.instance;
  }

// managing the user state via stream.
// stream provides an immediate event of
// the user's current authentication state,
// and then provides subsequent events whenever
// the authentication state changes.
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

//1
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Something Went Wrong.';
      }
    }
  }

//2
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'Something Went Wrong.';
      }
    } catch (e) {
      print(e);
      return 'Something Went Wrong.';
    }
  }

  Future<bool> handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      return true;
    } else {
      return false;
    }
  }

  Future login() async {
    await googleSignIn.signIn();
  }

  Future logout() async {
    await googleSignIn.signOut();
  }

  Future<bool> signInGoogle() async {
    // Reauthenticate user when app is opened
    final googleSignInAccount =
        await googleSignIn.signInSilently(suppressErrors: false);
    if (googleSignInAccount != null) {
      return true;
    } else {
      return false;
    }
    // // Detects when user signed in
    // googleSignIn.onCurrentUserChanged.listen((account) async {
    //   shouldNavigateToCreateAccount = await handleSignIn(account);
    // }, onError: (dynamic err) {
    //   print('Error signing in: $err');
    // });
  }

  Future createUserInFirestore(String userId, String displayName, String email,
      String photoUrl, String username) async {
    var timestamp = DateTime.now();
    try {
      var usr = RUser(
          id: userId,
          orgId: xnihiloOpsId,
          context: englishUs,
          createdBy: createdByUser,
          createdTime: timestamp,
          lastUpdatedBy: createdByUser,
          lastUpdatedTime: timestamp,
          bio: '',
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
          username: username);
      currentUser = await usr.upsert();
    } catch (e) {
      rethrow;
    }
  }
}
