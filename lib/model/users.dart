
class UserModel {
  String id; // Unique identifier for the user
  String username;
  String email;
  String? profilePic; // Defaults to a placeholder if not provided
  String? phone;
  List<String> eventIds; // References to events owned/participated
  List<String> pledgedGiftIds; // References to gifts owned/pledged
  List<String>? giftIds; // References to gifts owned/pledged
  List<String> friendIds; // References to friends (other User IDs)

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic = "sample.jpg", // Default profile picture
    this.phone,
    this.eventIds = const [],
    this.giftIds = const [],
    this.pledgedGiftIds = const [],
    this.friendIds = const [],
  });

  static UserModel? getUserById(String userId, List<UserModel> users) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null; // If no user is found, return null
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePic': profilePic,
      'phone': phone,
      'eventIds': eventIds,
      'giftIds': giftIds,
      'pledgedGiftIds': pledgedGiftIds,
      'friendIds': friendIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? "sample.jpg",
      phone: map['phone'],
      eventIds: List<String>.from(map['eventIds'] ?? []),
      giftIds: List<String>.from(map['giftIds'] ?? []),
      pledgedGiftIds: List<String>.from(map['pledgedGiftIds'] ?? []),
      friendIds: List<String>.from(map['friendIds'] ?? []),
    );
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
