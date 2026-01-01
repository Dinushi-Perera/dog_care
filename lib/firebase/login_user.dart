import 'package:firebase_auth/firebase_auth.dart';

class LoginUser {
    final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Registeruser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ User registered successfully! ${userCredential.user?.email}"); 
    } 
    on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");

      if (e.code == 'email-already-in-use') {
        throw Exception("The email address is already registered.");
      } else if (e.code == 'weak-password') {
        throw Exception("Password should be at least 6 characters.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email format.");
      } else {
        throw Exception("Failed to create user.");
      }
    }
    
    catch (e) {
      print("❌ Failed to register user: $e");
      throw Exception("Failed to register user.");
    }
  }

    Future<void> Loginuser({
    required String email,
    required String password,
  }) async {
    try {
       await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ User logged in successfully! ${email}");
    } 
    on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");

      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided for that user.");
      } else {
        throw Exception("Failed to login.");
      }
    } 
    catch (e) {
      print("❌ Failed to login user: $e");
      throw Exception("Failed to login user.");
    }
  }

  Future<void> Logoutuser() async {
    try {
      await _auth.signOut();
      print("✅ User logged out successfully!");
    } catch (e) {
      print("❌ Failed to log out user: $e");
      throw Exception("Failed to log out user.");
    }
  }
}