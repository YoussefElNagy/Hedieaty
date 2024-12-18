import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyeti/model/friendRequests.dart';
import 'package:hedeyeti/services/friend_request_service.dart';
import '../../model/users.dart';
import '../../services/users_service.dart';

class FriendRequestsViewModel {
  final UsersService usersService = UsersService();
  final FriendRequestService friendRequestService = FriendRequestService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch the sender's username
  Future<String> fetchRequestSenderUsername(String fromId) async {
    UserModel? sender = await usersService.getUser(fromId);
    return sender!.username;
  }

  // Fetch the sender's profile picture
  Future<String?> fetchRequestSenderProfilePic(String fromId) async {
    UserModel? sender = await usersService.getUser(fromId);
    return sender!.profilePic;
  }

  // Fetch all friend requests sent to the current user
  Future<List<FriendRequest>> fetchReceivedFriendRequests() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    List<FriendRequest> receivedRequests =
        await friendRequestService.getUserFriendRequests(currentUser.uid);
    return receivedRequests;
  }

  // Fetch details of the request sender
  Future<Map<String, dynamic>> fetchRequestSenderDetails(String fromId) async {
    String username = await fetchRequestSenderUsername(fromId);
    String? profilePic = await fetchRequestSenderProfilePic(fromId);

    return {
      'username': username,
      'profilePic': profilePic,
    };
  }

  // Initialize data: fetch all friend requests
  Future<Map<String, List<FriendRequest>>> initialiseData() async {
    List<FriendRequest> receivedRequests = await fetchReceivedFriendRequests();

    return {
      'receivedRequests': receivedRequests,
    };
  }

  // Get detailed data for a friend request
  Future<Map<String, dynamic>> getFriendRequestDetails(
      FriendRequest request) async {
    final senderDetails = await fetchRequestSenderDetails(request.fromId);

    return {
      'request': request,
      'senderDetails': senderDetails,
    };
  }

  Future<void> handleRequest(bool isAccepted, FriendRequest request) async {
    if (isAccepted) {
      await usersService.addFriendToUser(request.toId, request.fromId);
      await usersService.addFriendToUser(request.fromId, request.toId);
    }
    friendRequestService.deleteRequest(request.id);
  }
}
