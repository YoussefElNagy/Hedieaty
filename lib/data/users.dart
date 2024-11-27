class User {
  String id; // Unique identifier for the user
  String username;
  String email;
  String? profilePic; // Defaults to a placeholder if not provided
  String? phoneNumber;
  bool isEmailVerified;
  List<String> eventIds; // References to events owned/participated
  List<String> giftIds; // References to gifts owned/pledged
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
}
