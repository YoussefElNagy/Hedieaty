import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/services/common_service.dart';
import 'package:hedeyeti/services/users_service.dart';
import '../../model/events.dart';
import '../../model/users.dart';
import '../../services/events_service.dart';

class MyEventsViewModel {
  EventsService eventsService = EventsService();
  UsersService usersService = UsersService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CommonService commonService = CommonService();

  Future<UserModel?> fetchCurrentUser()async{
    UserModel? user= await usersService.getCurrentUserData();
    return user;
  }

  Future<List<Event>> fetchCurrentUserEvents() async {
    List<Event> events =
        await eventsService.getUserEvents(_auth.currentUser!.uid);
    return events;
  }

  Future<void> addNewEvent(String eventId,Event event) async {
    await eventsService.setEvent(eventId,event);
  }

  Future<void> deleteCurrentEvent(String eventId, String userId) async {
    try {
      await eventsService.deleteEvent(eventId, userId);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

  Future<void> updateCurrentEvent(String eventId,Event event)async{
    await eventsService.updateEvent(eventId, event);
  }

  String generateEventId() {
    return commonService.generateDocId('events');
  }

  Future<Map<String, dynamic>> initialiseData() async {
    final fetchedEvents = await fetchCurrentUserEvents();
    final fetchedUser = await fetchCurrentUser();
    return {'events': fetchedEvents, 'user': fetchedUser};
  }

  Future<void> createEvent(Event event) async {
    try {
      String eventId = event.id;
      await addNewEvent(eventId, event);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await updateCurrentEvent(event.id, event);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

}
