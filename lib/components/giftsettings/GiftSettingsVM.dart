import 'package:hedeyeti/services/gift_service.dart';
import '../../model/gifts.dart';
import '../../services/common_service.dart';
import '../../services/events_service.dart';
import '../../services/users_service.dart';

class GiftSettingsViewModel {
  GiftService giftService = GiftService();
  EventsService eventsService = EventsService();
  UsersService usersService = UsersService();
  CommonService commonService = CommonService();

  Future<void> deleteCurrentGift(Gift gift) async {
    try {
      await usersService.removeGiftFromUser(gift.ownerId, gift.id);
      await eventsService.removeGiftFromEvent(gift.eventId, gift.id);
      await giftService.deleteGift(gift.id);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

  Future<void> updateCurrentEvent(String giftId, Gift gift) async {
    await giftService.updateGift(giftId, gift);
  }

  Future<void> updateGift(Gift gift) async {
    try {
      await updateCurrentEvent(gift.id, gift);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

  String? validateGiftName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gift name is required';
    }
    return null;
  }

  String? validateGiftDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? validateGiftPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    final price = int.tryParse(value);
    if (price == null || price <= 0) {
      return 'Enter a valid price';
    }
    return null;
  }



}
