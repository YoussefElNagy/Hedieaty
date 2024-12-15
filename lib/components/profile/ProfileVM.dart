import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/model/events.dart';
import 'package:hedeyeti/model/gifts.dart';
import 'package:hedeyeti/model/users.dart';
import 'package:hedeyeti/services/events_service.dart';
import 'package:hedeyeti/services/gift_service.dart';
import 'package:hedeyeti/services/users_service.dart';

class ProfileViewModel{
  UsersService userService= UsersService();
  EventsService eventsService= EventsService();
  GiftService giftService= GiftService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> fetchCurrentUser()async{
    UserModel? user= await userService.getCurrentUserData();
    return user;
  }

  Future<List<Event>> fetchCurrentUserEvents()async{
    List<Event> events= await eventsService.getUserEvents(_auth.currentUser!.uid);
    return events;
  }

  Future<List<Gift>> fetchCurrentUserGifts()async{
    List<Gift> gifts= await giftService.getUserGifts(_auth.currentUser!.uid);
    return gifts;
  }

  Future<void> handleLogout()async {
    await _auth.signOut();
  }


}