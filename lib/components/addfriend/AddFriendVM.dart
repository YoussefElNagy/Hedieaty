// ViewModel Class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/services/users_service.dart';

import '../../model/users.dart';

class AddFriendViewModel {
  final UsersService usersService = UsersService();
  FirebaseAuth _auth= FirebaseAuth.instance;

  Future<List> fetchFriendToAdd(String searchQuery, String selectedSort) async {
    List allUsers = await usersService.getAllUsers();

    List<UserModel> userFriends = await usersService.getUserFriends();

    String currentUserId = _auth.currentUser!.uid;

    List<String> friendIds = userFriends.map((friend) => friend.id).toList();

    friendIds.add(currentUserId);

    List filteredUsers = allUsers
        .where((user) => !friendIds.contains(user.id)) // Exclude friends and self
        .toList();

    filteredUsers = applyFiltersAndSort(filteredUsers, searchQuery, selectedSort);

    return filteredUsers;
  }


  List applyFiltersAndSort(
      List friends, String searchQuery, String selectedSort) {
    if (searchQuery.isNotEmpty) {
      friends = friends
          .where((friend) =>
      friend.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
          friend.username.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    if (selectedSort == "Email") {
      friends.sort((a, b) => a.email.compareTo(b.email));
    } else if (selectedSort == "Username") {
      friends.sort((a, b) => a.username.compareTo(b.username));
    }
    return friends;
  }
  void addFriend(String userId){
    print("object");
  }

}
