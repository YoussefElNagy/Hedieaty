import 'package:cloud_firestore/cloud_firestore.dart';
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
      print("Error fetching all gifts: $e");
      return [];
    }
  }

  Future<List<Gift>> getUserGifts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('ownerId', isEqualTo: userId)
          .get();
      print("Fetched ${snapshot.docs.length} gifts");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all gifts: $e");
      return [];
    }
  }

  Future<List<Gift>> getUserPledgedGifts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('pledgedById', isEqualTo: userId)
          .get();
      print("Fetched ${snapshot.docs.length} pledged gifts");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching pledged gifts: $e");
      return [];
    }
  }

  Future<List<Gift>> getEventGifts(String eventId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('eventId', isEqualTo: eventId)
          .get();
      print("Fetched ${snapshot.docs.length} gifts");

      return snapshot.docs.map((doc) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all gifts: $e");
      return [];
    }
  }

  Future<void> addGift(Gift gift) async {
    try {
      await _firestore.collection(_collectionRef).add(gift.toMap());
    } catch (e) {
      print("Error adding gift: $e");
      rethrow;
    }
  }

  Future<void> setGift(String giftId, Gift gift) async {
    try {
      await _firestore.collection(_collectionRef).doc(giftId).set(gift.toMap());
      // await usersService.addEventToUser(event.ownerId, eventId); // Add to user
    } catch (e) {
      print("Error saving gift: $e");
      rethrow;
    }
  }

  Future<void> deleteGiftsByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('ownerId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("Deleted all gifts for user: \$userId");
    } catch (e) {
      print("Error deleting user gifts: \$e");
      rethrow;
    }
  }

  Future<void> deleteGiftsByEvent(String eventId) async {
    try {
      // Fetch and delete all gifts linked to the event
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionRef)
          .where('eventId', isEqualTo: eventId)
          .get();

      List<String> giftIdsToDelete =
          snapshot.docs.map((doc) => doc.id).toList();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Update users to remove deleted gift IDs
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      for (var userDoc in usersSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> userGiftIds = userData['giftIds'] ?? [];

        if (userGiftIds.isNotEmpty) {
          List<dynamic> updatedGiftIds =
              userGiftIds.where((id) => !giftIdsToDelete.contains(id)).toList();

          if (userGiftIds.length != updatedGiftIds.length) {
            await userDoc.reference.update({'giftIds': updatedGiftIds});
          }
        }
      }
      print(
          "Deleted all gifts for event: $eventId and updated user gift lists");
    } catch (e) {
      print("Error deleting event gifts: $e");
      rethrow;
    }
  }

  //user= kaza w user.field
  Future<Gift?> getGift(String giftId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionRef).doc(giftId).get();

      if (doc.exists && doc.data() != null) {
        return Gift.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No gift found with ID: $giftId");
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
