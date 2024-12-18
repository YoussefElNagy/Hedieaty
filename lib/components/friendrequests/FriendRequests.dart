import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/friendrequests/FriendRequestsVM.dart';
import 'package:hedeyeti/model/friendRequests.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  final _viewModel = FriendRequestsViewModel();
  late Future<List<FriendRequest>> requestsFuture;

  @override
  void initState() {
    super.initState();
    requestsFuture = _viewModel.fetchReceivedFriendRequests();
  }

  void refreshRequests() {
    setState(() {
      requestsFuture = _viewModel.fetchReceivedFriendRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friend Requests',
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<FriendRequest>>(
          future: requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Error loading data");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("You have no pending friend requests");
            }

            final receivedRequests = snapshot.data!;

            return ListView.builder(
              itemCount: receivedRequests.length,
              itemBuilder: (context, index) {
                final request = receivedRequests[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    color: theme.colorScheme.surface,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //     color: theme.colorScheme.primary, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: theme.colorScheme.tertiary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: _viewModel.getFriendRequestDetails(request),
                          builder: (context, detailsSnapshot) {
                            if (detailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(
                                title: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (detailsSnapshot.hasError) {
                              return const ListTile(
                                title: Text("Error loading user details"),
                              );
                            } else if (detailsSnapshot.hasData) {
                              final details = detailsSnapshot.data!;
                              final username = details['senderDetails']
                                      ['username'] ??
                                  'Unknown';
                              final profilePic = details['senderDetails']
                                      ['profilePic'] ??
                                  'assets/default_avatar.png';

                              return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 8.0),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        profilePic.startsWith('http')
                                            ? NetworkImage(profilePic)
                                            : AssetImage(profilePic)
                                                as ImageProvider,
                                  ),
                                  title: Text(
                                    username,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    'Sent a friend request',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check),
                                        iconSize:
                                            30.0, // Adjust the icon size here
                                        color: theme.colorScheme.primary,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical:
                                                8.0), // Adjust padding here
                                        onPressed: () {
                                          _viewModel.handleRequest(
                                              true, request);
                                          refreshRequests;
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        iconSize:
                                            30.0, // Adjust the icon size here
                                        color: theme.colorScheme.error,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical:
                                                8.0), // Adjust padding here
                                        onPressed: () {
                                          _viewModel.handleRequest(
                                              false, request);
                                          refreshRequests;
                                        },
                                      ),
                                    ],
                                  ));
                            } else {
                              return const ListTile(
                                title: Text("No details available"),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
