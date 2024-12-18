import 'package:hedeyeti/services/events_service.dart';
import 'package:hedeyeti/services/users_service.dart';
import '../../model/events.dart';
import '../../model/users.dart';

class EventsViewModel{
 UsersService usersService=UsersService();
 EventsService eventsService=EventsService();

 Future<List<String>> fetchFriendIds()async{
   UserModel? user= await usersService.getCurrentUserData();
   return user!.friendIds;
 }

 Future<String> fetchEventOwnerUsername(String ownerId)async{
   UserModel? owner= await usersService.getUser(ownerId);
   return owner!.username;
 }

 Future<String?> fetchEventOwnerProfilePic(String ownerId)async{
   UserModel? owner= await usersService.getUser(ownerId);
   return owner!.profilePic;
 }

 Future<UserModel?> fetchEventOwner(String ownerId)async{
   UserModel? owner= await usersService.getUser(ownerId);
   return owner;
 }
 Future<List<Event>> fetchUserEvents(String userId) async {
   final events = await eventsService.getUserEvents(userId);
   return events;
 }

 Future<List<Event>> fetchFriendEvents(List<String> friendIds) async {
   List<Event> allEvents = [];

   for (var friendId in friendIds) {
     List<Event> friendEvents = await fetchUserEvents(friendId);
     allEvents.addAll(friendEvents);
   }

   return allEvents;
 }

 Future<List<Event>> initialiseData() async {
   final fetchedFriendIds=await fetchFriendIds();
   final fetchedEvents = await fetchFriendEvents(fetchedFriendIds);
   return fetchedEvents;
 }

 Future<Map<String, dynamic>> fetchEventOwnerDetails(String ownerId) async {
   final fetchedUsername = await fetchEventOwnerUsername(ownerId);
   final fetchedProfilePic = await fetchEventOwnerProfilePic(ownerId);
   return {'username': fetchedUsername, 'profilePic': fetchedProfilePic};
 }

 Future<Map<String, dynamic>> getEventDetails(Event event) async {
   final ownerDetails = await fetchEventOwnerDetails(event.ownerId);
   return {
     'event': event,
     'ownerDetails': ownerDetails,
   };
 }

 Future<List<Event>> getFilteredEvents(String filterStatus, bool isSortedAscending) async {
   List<Event> events = await initialiseData();
   DateTime currentDate = DateTime.now();

   // Apply filter
   if (filterStatus == 'Upcoming') {
     events = events.where((event) => event.dateTime.isAfter(currentDate)).toList();
   } else if (filterStatus == 'Passed') {
     events = events.where((event) => event.dateTime.isBefore(currentDate)).toList();
   }

   // Sort the events
   events.sort((a, b) => isSortedAscending
       ? a.dateTime.compareTo(b.dateTime)
       : b.dateTime.compareTo(a.dateTime));

   return events;
 }

}