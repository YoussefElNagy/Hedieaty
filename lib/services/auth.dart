import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  FirebaseAuth _auth= FirebaseAuth.instance;
  Future<User?> signUp({
  required String email, required String password
  }) async{
    try{
      UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }
    on FirebaseAuthException catch(e){
      print('Error: ${e.message}');
      throw e;
    }
  }

  Future<User?> signIn({
    required String email, required String password
  }) async{
    try{
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }
    on FirebaseAuthException catch(e){
      print('Error: ${e.message}');
      throw e;
    }
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getUserData() async{
    User? user= _auth.currentUser;
    try{
      return FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    }

    catch(e) {
      return Future.error("No user signed in!");
    }
  }

  Future<void> saveUserData({required String username, required String email}) async{
    User? user= _auth.currentUser;
    if(user!=null) {
      String uid= user.uid;
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email
      });
    }
  }

}