import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/users.dart';

class UsersService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(
      {required String username,
      required String email,
      required String phone,
      required String gender}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String profilePic= gender=="male"?"assets/male.png":"assets/female.jpg";
      _firestore.collection('users').doc(uid).set({
        'id': user.uid,
        'username': username,
        'email': email,
        'phone': phone,
        'profilePic': profilePic,
        'friendIds': [],
        'eventIds': [],
        'giftIds': [],
        'pledgedGiftsIds': [],
      });
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      print("Fetched ${snapshot.docs.length} users");

      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all workouts: $e");
      return [];
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    print(user?.uid);
    try {
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        // Check if the document exists and map the data to a UserModel
        if (snapshot.exists) {
          return UserModel.fromMap(
              snapshot.data() as Map<String, dynamic>, snapshot.id);
        } else {
          print("No user data found!");
          return null;
        }
      } else {
        throw Exception("No user signed in!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> printUserData() async {
    try {
      // Await the result of getUserData
      UserModel? user = await getCurrentUserData();

      if (user != null) {
        // Print the UserModel properties
        print("User data: ${user.username}, ${user.email}, ${user.phone}");
      } else {
        print("No user data found!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  //user= kaza w user.field
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No user found with ID: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching user object: $e");
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  Future<void> updateUser(String userId, UserModel user) async {
    try {
      await _firestore.collection('user').doc(userId).update(user.toMap());
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<List<UserModel>> getUserFriends() async {
    try {
      User? user = _auth.currentUser;

      // Fetch the user's document
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user?.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        // Extract the list of friend IDs
        List<String> friendIds = List<String>.from(
            (userDoc.data() as Map<String, dynamic>)['friendIds'] ?? []);

        if (friendIds.isEmpty) {
          print("No friends found for user: ${user?.uid}");
          return [];
        }

        // Fetch friends' documents in parallel
        List<UserModel?> friends =
            await Future.wait(friendIds.map((friendId) async {
          DocumentSnapshot friendDoc =
              await _firestore.collection('users').doc(friendId).get();
          if (friendDoc.exists && friendDoc.data() != null) {
            return UserModel.fromMap(
                friendDoc.data() as Map<String, dynamic>, friendDoc.id);
          }
          return null; // If a friend document doesn't exist
        }));

        // Filter out null results
        return friends.whereType<UserModel>().toList();
      } else {
        print("User not found.");
        return [];
      }
    } catch (e) {
      print("Error fetching user friends: $e");
      return [];
    }
  }

  Future<void> printUserFriends() async {
    List<UserModel> friends = await getUserFriends();

    if (friends.isNotEmpty) {
      for (var friend in friends) {
        print("Friend: ${friend.username}, Email: ${friend.email}");
      }
    } else {
      print("No friends found!");
    }
  }

  Future<void> addEventToUser(String userId, String eventId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'eventIds': FieldValue.arrayUnion([eventId])
      });
      print("Event added successfully!");
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  Future<void> removeEventFromUser(String userId, String eventId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'eventIds': FieldValue.arrayRemove([eventId])
      });
      print("Event removed successfully!");
    } catch (e) {
      print("Error removing event: $e");
      rethrow;
    }
  }

  Future<void> addGiftToUser(String userId, String giftId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'giftIds': FieldValue.arrayUnion([giftId])
      });
      print("Gift added successfully to user $userId!");
    } catch (e) {
      print("Error adding gift: $e to user");
      rethrow;
    }
  }

  Future<void> addPledgedGiftToUser(String userId, String giftId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'pledgedGiftsIds': FieldValue.arrayUnion([giftId])
      });
      print("Gift pledged successfully by user $userId!");
    } catch (e) {
      print("Error pledging gift: $e by user");
      rethrow;
    }
  }

  Future<void> addFriendToUser(String userId, String friendId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'friendIds': FieldValue.arrayUnion([friendId])
      });
      print("Friend added successfully to user $userId!");
    } catch (e) {
      print("Error adding friend: $e to user");
      rethrow;
    }
  }

  Future<void> removeFriendFromUser(String userId, String friendId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'friendIds': FieldValue.arrayRemove([friendId])
      });
      print("Friend removed successfully from user $userId!");
    } catch (e) {
      print("Error removing friend: $e from user");
      rethrow;
    }
  }

  Future<void> removeGiftFromUser(String userId, String giftId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'giftIds': FieldValue.arrayRemove([giftId])
      });
      print("gift removed successfully from user!");
    } catch (e) {
      print("Error removing gift from user: $e");
      rethrow;
    }
  }

  Future<void> removePledgedGiftToUser(String userId, String giftId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'pledgedGiftsIds': FieldValue.arrayRemove([giftId])
      });
      print("Gift unpledged successfully by user $userId!");
    } catch (e) {
      print("Error unpledging gift: $e by user");
      rethrow;
    }
  }
}
