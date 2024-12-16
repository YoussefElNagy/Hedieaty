import 'package:firebase_auth/firebase_auth.dart';
import '../../model/gifts.dart';
import '../../services/gift_service.dart';
import '../../services/users_service.dart';

class MyGiftsViewModel {
  UsersService userService = UsersService();
  GiftService giftService = GiftService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Gift>> fetchCurrentUserGifts() async {
    List<Gift> gifts = await giftService.getUserGifts(_auth.currentUser!.uid);
    return gifts;
  }

  Future<List<Gift>> fetchCurrentEventGifts(String eventId) async {
    List<Gift> gifts = await giftService.getEventGifts(eventId);
    return gifts;
  }


  Future<Map<String, dynamic>> initialiseData() async {
    final fetchedGifts = await fetchCurrentUserGifts();
    return {
      'gifts': fetchedGifts,
    };
  }

  Future<Map<String, dynamic>> initialiseEventData(eventId) async {
    final fetchedGifts = await fetchCurrentEventGifts(eventId);
    return {
      'gifts': fetchedGifts,
    };
  }

  List applyFiltersAndSort(List gifts, String searchQuery, String selectedSort,
      String selectedFilter) {
    // Apply filtering based on searchQuery, selectedSort, and selectedFilter
    if (searchQuery.isNotEmpty) {
      gifts = gifts
          .where((gift) => gift.giftName.toLowerCase().contains(searchQuery))
          .toList();
    }

    if (selectedFilter != "All") {
      bool isPledged = selectedFilter == "Pledged";
      gifts = gifts.where((gift) => gift.isPledged == isPledged).toList();
    }

    // Sorting
    if (selectedSort == "Name") {
      gifts.sort((a, b) => a.giftName.compareTo(b.giftName));
    } else if (selectedSort == "Price") {
      gifts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == "Category") {
      gifts.sort((a, b) => a.category.name.compareTo(b.category.name));
    }

    return gifts;
  }
}
