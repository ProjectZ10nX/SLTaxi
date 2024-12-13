import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mrdrop/services/AppUser.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Phone Authentication
  static Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  static Future<bool> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create User in Firestore
  static Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
      });
    }
  }

  // Send Email Verification
  static Future<void> sendEmailVerification({
    required String email,
    required String password,
  }) async {
    try {
      // Create email/password account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await result.user?.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  // Check Email Verification Status
  static Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  //Get Current User
  static Future<AppUser?> currentUser(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        // Parse Firestore document into AppUser
        return AppUser.fromFirestore(doc.data()!);
      } else {
        print("User document not found for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
