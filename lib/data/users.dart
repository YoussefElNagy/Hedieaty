import 'events.dart';

class User {
  String id; // Unique identifier for the user
  String username;
  String email;
  String? profilePic; // Defaults to a placeholder if not provided
  String? phoneNumber;
  bool isEmailVerified;
  List<String> eventIds; // References to events owned/participated
  List<String> pledgedGiftIds; // References to gifts owned/pledged
  List<String>? giftIds; // References to gifts owned/pledged
  List<String> friendIds; // References to friends (other User IDs)

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic = "default_avatar.png", // Default profile picture
    this.phoneNumber,
    this.isEmailVerified = false,
    this.eventIds = const [],
    this.giftIds = const [],
    this.pledgedGiftIds = const [],
    this.friendIds = const [],
  });

  // Making getUserById static so it can be called without an instance of User
  static User? getUserById(String userId, List<User> users) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null; // If no user is found, return null
    }
  }

  // List<Event> getUserEvents() {
//   //   List<Event> userEvents = [];
//   //
//   //   // Iterate over the eventIds of the user and find corresponding events
//   //   for (String eventId in eventIds) {
//   //     Event? event = Event.getEventById(eventId); // Use the static method without passing a list
//   //     if (event != null) {
//   //       userEvents.add(event);
//   //     }
//   //   }
//   //   return userEvents;
//   // }
}
