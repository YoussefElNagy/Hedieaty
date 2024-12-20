import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedeyeti/components/(auth)/LoginScreen.dart';
import 'package:hedeyeti/components/friendrequests/FriendRequests.dart';
import 'package:hedeyeti/components/mygifts/GiftManagement.dart';
import 'package:hedeyeti/components/giftsettings/GiftSettings.dart';
import 'package:hedeyeti/components/profile/ProfileSettings.dart';
import 'package:hedeyeti/components/profile/ProfileVM.dart';
import 'package:intl/intl.dart';
import '../pledgedgifts/PledgedGifts.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    futureData = initialiseData();
    super.initState();
  }

  Future<Map<String, dynamic>> initialiseData() async {
    ProfileViewModel profileViewModel = ProfileViewModel();
    final fetchedUser = await profileViewModel.fetchCurrentUser();
    final fetchedEvents = await profileViewModel.fetchCurrentUserEvents();
    final fetchedGifts = await profileViewModel.fetchCurrentUserGifts();
    return {
      'user': fetchedUser,
      'events': fetchedEvents,
      'gifts': fetchedGifts,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading data"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available"));
            }
            final user = snapshot.data!['user'];
            final events = snapshot.data!['events'];
            final gifts = snapshot.data!['gifts'];
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background image with blur effect
                      Image.asset(
                        user?.profilePic ??
                            'assets/default_avatar.png', // Use a placeholder if null
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // Apply the blur effect using BackdropFilter
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.black.withOpacity(0),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(user?.profilePic ??
                              'assets/default.png'), // Use placeholder if null
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Username and Email
                  Text(
                    user!.username,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    user?.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Edit Profile Button and Pledged Gifts Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileSettingsPage()));
                        },
                        child: Text(
                          'Edit profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PledgedGiftsPage(currentUserId: user?.id),
                            ),
                          );
                        },
                        child: Text(
                          'Pledged Gifts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${user?.friendIds.length} friend${user?.friendIds.length == 1 ? "" : "s"} ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                          "Wishlist: ${gifts.length} gift${gifts.length == 1 ? "" : "s"}",
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FriendRequests(),
                        ),
                      );
                    },
                    child: Text(
                      'Friend Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // Display Events List
                  // Display Events List
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Divider(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Divider(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        // List of events
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  leading: Icon(
                                    Icons.event,
                                    size: 42,
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    event.eventName,
                                    style: TextStyle(
                                      color: theme.colorScheme.surface,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime),
                                          style: TextStyle(
                                            color: theme.colorScheme.surface,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: theme.colorScheme.primary,
                                              size: 20,
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: theme.colorScheme.surface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GiftManagement(event: event),
                                      ),
                                    );
                                  },
                                ),
                              )

                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Divider(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // Gifts List
                  Text(
                    'My Wishlist',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Divider(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // List of gifts
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gifts.length ?? 0,
                itemBuilder: (context, index) {
                  final gift = gifts[index] ?? "No gift found";
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.colorScheme.primary,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              gift.image ?? "assets/default_gift.png",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gift.giftName,
                                style: TextStyle(
                                  color: theme.colorScheme.surface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 4),
                              Text(
                                gift.isPledged ? "Pledged" : "Not pledged",
                                style: TextStyle(
                                  color: !gift.isPledged
                                      ? Colors.orangeAccent
                                      : theme.colorScheme.tertiary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GiftSettings(gift: gift),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        key: Key("logoutBtn"),
                          onPressed: () {
                            ProfileViewModel().handleLogout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
