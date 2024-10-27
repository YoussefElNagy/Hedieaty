import 'event.dart';

class Friend{
  String username;
  int upcomingEvents;
  String profilePic;
  String phoneNumber;
  List <Event> events;
  Friend({
    required this.username,
    required this.upcomingEvents,
    required this.profilePic,
    required this.phoneNumber,
    required this.events,
});
}

