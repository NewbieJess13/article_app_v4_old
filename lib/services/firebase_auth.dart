import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:article_app_v4/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthMethod {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User userFromFirebase(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get userAuthState {
    return _auth.authStateChanges().map(userFromFirebase);
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;
      await HelperPrefs.saveFullNameInPrefs(user.displayName);
      await HelperPrefs.saveUserImageInPrefs(user.photoURL);
      await HelperPrefs.saveUserEmailInPrefs(user.email);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInWithEmailandPassword(String email, String password) async {
    try {
      auth.UserCredential userResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      auth.User firebaseUser = userResult.user;
      //print('user uid ${firebaseUser.uid}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signUpWithEmailandPassword(String email, String password) async {
    try {
      auth.UserCredential userResult =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      auth.User firebaseUser = userResult.user;
      //print('user uid ${firebaseUser.uid}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOutGoogle() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }
}
