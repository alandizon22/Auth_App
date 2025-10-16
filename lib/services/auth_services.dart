import 'package:firebase_auth/firebase_auth.dart';

class AuthService {


  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? get currentUser => _auth.currentUser;


  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signIn ({
    required String email,
    required String password,


  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password
      ); return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthAException(e);
    }
  }

  Future<String?> register ({
    required String email,
    required String password
  }) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      ); await result.user?.sendEmailVerification();
      return null;
    }on FirebaseAuthException catch (e) {
      return _handleAuthAException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthAException(e);
    }
  }


  String _handleAuthAException(FirebaseAuthException e) {
    switch(e.code){
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong password':
        return 'Wrong password provided';
      case 'Email-already-in-used':
        return  'An account already exist with this email';
      case 'Invalid-email':
        return 'The email address was invalid';
      case 'weak password':
        return 'The password is too weak';
      case 'operation-is-not-allowed':
        return 'Operation is not allowed, please contact Blackbox';
      case 'user-disabled':
        return 'This User account has been disabled';
      default:
        return 'An error occurred, please try again';

    }
  }
}