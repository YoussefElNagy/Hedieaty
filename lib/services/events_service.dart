import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/events.dart';

class EventsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionRef = 'events'; // Updated collection name

  Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionRef).get();
      print("Fetched ${snapshot.docs.length} events");

      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all events: $e");
      return [];
    }
  }

  Future<List<Event>> getUserEvents(String userId) async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection(_collectionRef).where('ownerId', isEqualTo: userId).get();
      print("Fetched ${snapshot.docs.length} events");

      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all events: $e");
      return [];
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection(_collectionRef).add(event.toMap());
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  //user= kaza w user.field
  Future<Event?> getEvent(String eventId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionRef).doc(eventId).get();

      if (doc.exists && doc.data() != null) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No event found with ID: $eventId");
        return null;
      }
    } catch (e) {
      print("Error fetching user object: $e");
      return null;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collectionRef).doc(eventId).delete();
    } catch (e) {
      print("Error deleting event: $e");
      rethrow;
    }
  }

  Future<void> updateEvent(String eventId, Event event) async {
    try {
      await _firestore
          .collection(_collectionRef)
          .doc(eventId)
          .update(event.toMap());
    } catch (e) {
      print("Error updating event: $e");
      rethrow;
    }
  }
}
