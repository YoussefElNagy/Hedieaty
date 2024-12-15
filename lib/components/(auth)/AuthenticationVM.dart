import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth.dart';
import '../../services/users_service.dart';

class AuthenticationViewModel {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Future<void> signUp({email, password, username, phone}) async {
    await Auth().signUp(email: email, password: password);
    await UsersService()
        .saveUserData(username: username, email: email, phone: phone);
  }

  Future<User?> signIn({email, password}) async {
    var user = await Auth().signIn(email: email, password: password);
    return user;
  }
}
