// ViewModel Class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/services/friend_request_service.dart';
import 'package:hedeyeti/services/users_service.dart';
import '../../model/users.dart';

class AddFriendViewModel {
  final UsersService usersService = UsersService();
  final FriendRequestService friendRequestService= FriendRequestService();
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
  Future<void> sendFriendRequest(String userId)async{
    try{
      await friendRequestService.setFriendRequest(_auth.currentUser!.uid, userId);
    }
    catch(e){
      print("Error sending request");
    }

    print("object");
  }

}
