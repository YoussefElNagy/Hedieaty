import 'package:cloud_firestore/cloud_firestore.dart';

enum EventCategory {
  birthday,
  wedding,
  corporate,
  entertainment,
  graduation,
  eid,
  engagement,
  other
}

class Event {
  String id; // Unique identifier for the event
  String eventName;
  String ownerId; // Reference to the User who owns the event
  DateTime dateTime;
  String? location;
  EventCategory category; // Enum for event type
  List<String> giftIds; // References to associated gifts

  Event(
      {required this.id,
      required this.eventName,
      required this.ownerId,
      required this.dateTime,
      required this.category,
      this.giftIds = const [],
      this.location});

  static Event? getEventById(String eventId, List<Event> events) {
    try {
      return events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null; // If no event is found, return null
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'ownerId': ownerId,
      'dateTime': dateTime,
      'category': category,
      'location': location,
      'giftIds': giftIds,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      eventName: map['eventName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      category: map['category'],
      location: map['location'],
      giftIds: List<String>.from(map['giftIds'] ?? []),
    );
  }
}
