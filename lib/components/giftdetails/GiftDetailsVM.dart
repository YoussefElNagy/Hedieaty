import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/services/gift_service.dart';
import 'package:hedeyeti/services/users_service.dart';
import '../../model/gifts.dart';
import '../../model/users.dart';

class GiftDetailsViewModel {
  UsersService usersService = UsersService();
  GiftService giftService = GiftService();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> fetchGiftOwner(Gift gift) async {
    UserModel? owner = await usersService.getUser(gift.ownerId);
    return owner;
  }

  Future<Map<String, dynamic>> initialiseEventData(Gift gift) async {
    final fetchedUser = await fetchGiftOwner(gift);
    return {'owner': fetchedUser};
  }

  Future<void> handlePledge(Gift gift) async {
    try {
      final updatedGift = Gift(
          id: gift.id,
          giftName: gift.giftName,
          ownerId: gift.ownerId,
          category: gift.category,
          image: gift.image,
          isPledged: true,
          description: gift.description,
          price: gift.price,
          pledgedById: _auth.currentUser!.uid,
          eventId: gift.eventId);
      await giftService.updateGift(updatedGift.id, updatedGift);
      await usersService.addPledgedGiftToUser(
          _auth.currentUser!.uid, updatedGift.id);
    } catch (e) {
      rethrow;
    }
  }

  bool isUnpledgeAllowed(Gift gift) {
    if (_auth.currentUser!.uid == gift.pledgedById)
      return true;
    else {
      return false;
    }
  }

  Future<void> handleUnpledge(Gift gift) async {
    if (isUnpledgeAllowed(gift)) {
      try {
        final updatedGift = Gift(
            id: gift.id,
            giftName: gift.giftName,
            ownerId: gift.ownerId,
            category: gift.category,
            image: gift.image,
            isPledged: false,
            description: gift.description,
            price: gift.price,
            pledgedById: "",
            eventId: gift.eventId);
        await giftService.updateGift(updatedGift.id, updatedGift);
        await usersService.removePledgedGiftToUser(
            _auth.currentUser!.uid, updatedGift.id);
      } catch (e) {
        rethrow;
      }
    }
  }
}
