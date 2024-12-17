import 'package:hedeyeti/model/users.dart';
import '../../model/events.dart';
import '../../model/gifts.dart';
import '../../services/events_service.dart';
import '../../services/gift_service.dart';
import '../../services/users_service.dart';

class MyFriendsViewModel {
  UsersService userService = UsersService();
  EventsService eventsService = EventsService();
  GiftService giftService = GiftService();

  Future<List<UserModel>> fetchCurrentUserFriends() async {
    List<UserModel> friends = await userService.getUserFriends();
    return friends;
  }

  Future<Map<String, dynamic>> initialiseData() async {
    final fetchedFriends = await fetchCurrentUserFriends();
    return {
      'friends': fetchedFriends,
    };
  }

  Future<List<Event>> fetchUserEvents(String userId) async {
    List<Event> events = await eventsService.getUserEvents(userId);
    return events;
  }

  Future<List<Gift>> fetchUserGifts(String userId) async {
    List<Gift> gifts = await giftService.getUserGifts(userId);
    return gifts;
  }

  Future<Map<String, dynamic>> initialiseFriendData(String userId) async {
    final fetchedEvents = await fetchUserEvents(userId);
    final fetchedGifts = await fetchUserGifts(userId);
    return {
      'events': fetchedEvents,
      'gifts': fetchedGifts,
    };
  }
}
