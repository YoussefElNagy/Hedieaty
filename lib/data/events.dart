enum EventStatus { active, cancelled, completed, upcoming }
enum EventCategory { birthday, wedding, corporate,  entertainment, graduation, eid, other }

class Event {
  String id; // Unique identifier for the event
  String eventName;
  String ownerId; // Reference to the User who owns the event
  DateTime dateTime;
  EventCategory category; // Enum for event type
  EventStatus status; // Enum for event status
  List<String> giftIds; // References to associated gifts

  Event({
    required this.id,
    required this.eventName,
    required this.ownerId,
    required this.dateTime,
    required this.category,
    required this.status,
    this.giftIds = const [],
  });

  static Event? getEventById(String eventId, List<Event> events) {
    try {
      return events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null; // If no event is found, return null
    }
  }
}
