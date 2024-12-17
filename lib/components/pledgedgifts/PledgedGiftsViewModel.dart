import 'package:firebase_auth/firebase_auth.dart';
import '../../model/gifts.dart';
import '../../services/gift_service.dart';
import '../../services/users_service.dart';

class PledgedGiftsViewModel {
  UsersService userService = UsersService();
  GiftService giftService = GiftService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Gift>> fetchUserPledgedGifts() async {
    List<Gift> gifts = await giftService.getUserPledgedGifts(_auth.currentUser!.uid);
    return gifts;
  }

  Future<Map<String, dynamic>> initialiseData() async {
    final fetchedGifts = await fetchUserPledgedGifts();
    return {
      'pledgedGifts': fetchedGifts,
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
