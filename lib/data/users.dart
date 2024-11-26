import 'events.dart';

class User{
  String username;
  int upcomingEvents;
  String? profilePic;
  String phoneNumber;
  String email;
  List <Event> events;
  List <String>? gifts;

  User({
    required this.username,
    required this.upcomingEvents,
    this.profilePic,
    required this.phoneNumber,
    required this.email,
    required this.events,
    this.gifts
});
}

