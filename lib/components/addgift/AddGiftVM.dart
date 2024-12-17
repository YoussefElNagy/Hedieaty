import 'package:hedeyeti/services/events_service.dart';
import 'package:hedeyeti/services/gift_service.dart';
import '../../model/gifts.dart';
import '../../model/users.dart';
import '../../services/common_service.dart';
import '../../services/users_service.dart';

class AddGiftViewModel {
  GiftService giftService = GiftService();
  EventsService eventsService = EventsService();
  UsersService usersService = UsersService();
  CommonService commonService = CommonService();

  Future<UserModel?> fetchCurrentUser() async {
    UserModel? user = await usersService.getCurrentUserData();
    return user;
  }

  Future<void> addNewGift(String giftId, Gift gift) async {
    try {
      await giftService.setGift(giftId, gift);
      await usersService.addGiftToUser(gift.ownerId, gift.id);
      await eventsService.addGiftToEvent(gift.eventId, gift.id);
    } catch (e) {
      rethrow; // Handle exceptions
    }
  }

  String generateGiftId() {
    return commonService.generateDocId('gifts');
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
  Map<String, String> categoryImages = {
    'electronics': 'assets/electronics.jpg',
    'clothing': 'assets/clothing.jpg',
    'cosmetics': 'assets/cosmetics.jpg',
    'toys': 'assets/toys.jpg',
    'home': 'assets/home.jpg',
    'other': 'assets/other.jpg',
  };
}
