import 'package:cloud_firestore/cloud_firestore.dart';

class CommonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateDocId(collectionRef) {
    return _firestore.collection(collectionRef).doc().id;
  }

}