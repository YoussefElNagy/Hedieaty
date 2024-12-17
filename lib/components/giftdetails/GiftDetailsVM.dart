import 'package:hedeyeti/services/users_service.dart';

import '../../model/gifts.dart';
import '../../model/users.dart';

class GiftDetailsViewModel{
  UsersService usersService= UsersService();

  Future<UserModel?> fetchGiftOwner(Gift gift)async{
    UserModel? owner= await usersService.getUser(gift.ownerId);
    return owner;
  }

  Future<Map<String, dynamic>> initialiseEventData(Gift gift) async {
    final fetchedUser = await fetchGiftOwner(gift);
    return {
      'owner': fetchedUser
    };
  }
}