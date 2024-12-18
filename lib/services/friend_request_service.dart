import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedeyeti/services/common_service.dart';

import '../model/friendRequests.dart';

class FriendRequestService {
  final String _collectionRef = 'friendRequests'; // Updated collection name
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CommonService commonService = CommonService();
  Future<List<FriendRequest>> getAllRequests() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionRef).get();
      print("Fetched ${snapshot.docs.length} requests");

      return snapshot.docs.map((doc) {
        return FriendRequest.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all requests: $e");
      return [];
    }
  }

  Future<List<FriendRequest>> getUserFriendRequests(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('toId', isEqualTo: userId)
          .get();
      print("Fetched ${snapshot.docs.length} requests");

      return snapshot.docs.map((doc) {
        return FriendRequest.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all requests: $e");
      return [];
    }
  }

  Future<void> setFriendRequest(String fromId, String toId) async {
    final id = commonService.generateDocId(_collectionRef);
    final request = FriendRequest(id: id, fromId: fromId, toId: toId);
    try {
      await _firestore.collection(_collectionRef).doc(id).set(request.toMap());
    } catch (e) {
      print("Error saving request: $e");
      rethrow;
    }
  }

  Future<void> deleteRequest(String id) async {
    try {
      await _firestore.collection(_collectionRef).doc(id).delete();
    } catch (e) {
      print("Error deleting request: $e");
      rethrow;
    }
  }
}
