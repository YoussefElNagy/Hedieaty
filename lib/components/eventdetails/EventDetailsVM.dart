import 'package:hedeyeti/model/users.dart';
import 'package:hedeyeti/services/gift_service.dart';

import '../../model/events.dart';
import '../../model/gifts.dart';
import '../../services/events_service.dart';
import '../../services/users_service.dart';

class EventDetailsViewModel{
  EventsService eventsService = EventsService();
  UsersService usersService = UsersService();
  GiftService giftService = GiftService();


  Future<List<Gift>> fetchEventGifts(String eventId) async {
    List<Gift> gifts = await giftService.getEventGifts(eventId);
    return gifts;
  }

  Future<UserModel?> fetchEventOwner(Event event)async{
    UserModel? owner= await usersService.getUser(event.ownerId);
    return owner;
  }

  Future<Map<String, dynamic>> initialiseEventData(Event event) async {
    final fetchedGifts = await fetchEventGifts(event.id);
    final fetchedUser = await fetchEventOwner(event);
    return {
      'gifts': fetchedGifts,
      'owner': fetchedUser
    };
  }

}