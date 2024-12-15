import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/events.dart';
import '../model/gifts.dart';

class GiftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionRef = 'gifts'; // Updated collection name

  Future<List<Gift>> getAllGifts() async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection(_collectionRef).get();
      print("Fetched ${snapshot.docs.length} Gifts");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all events: $e");
      return [];
    }
  }

  Future<List<Gift>> getUserGifts(String userId) async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection(_collectionRef).where('ownerId', isEqualTo: userId).get();
      print("Fetched ${snapshot.docs.length} events");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all events: $e");
      return [];
    }
  }

  Future<List<Gift>> getEventGifts(String eventId) async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection(_collectionRef).where('eventId', isEqualTo: eventId).get();
      print("Fetched ${snapshot.docs.length} gifts");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all gifts: $e");
      return [];
    }
  }

  Future<void> addGift(Event event) async {
    try {
      await _firestore.collection(_collectionRef).add(event.toMap());
    } catch (e) {
      print("Error adding gift: $e");
      rethrow;
    }
  }

  //user= kaza w user.field
  Future<Gift?> getGift(String eventId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection(_collectionRef).doc(eventId).get();

      if (doc.exists && doc.data() != null) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No gift found with ID: $eventId");
        return null;
      }
    } catch (e) {
      print("Error fetching gift object: $e");
      return null;
    }
  }

  Future<void> deleteGift(String giftId) async {
    try {
      await _firestore.collection(_collectionRef).doc(giftId).delete();
    } catch (e) {
      print("Error deleting gift: $e");
      rethrow;
    }
  }

  Future<void> updateGift(String giftId, Gift gift) async {
    try {
      await _firestore
          .collection(_collectionRef)
          .doc(giftId)
          .update(gift.toMap());
    } catch (e) {
      print("Error updating gift: $e");
      rethrow;
    }
  }
}
