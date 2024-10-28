import 'events.dart';

class Friend{
  String username;
  int upcomingEvents;
  String? profilePic;
  String phoneNumber;
  List <Event> events;
  Friend({
    required this.username,
    required this.upcomingEvents,
    this.profilePic,
    required this.phoneNumber,
    required this.events,
});
}

