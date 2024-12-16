import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedeyeti/components/(auth)/LoginScreen.dart';
import 'package:hedeyeti/components/mygifts/GiftManagement.dart';
import 'package:hedeyeti/components/giftsettings/GiftSettings.dart';
import 'package:hedeyeti/components/profile/ProfileVM.dart';
import 'package:intl/intl.dart';
import '../PledgedGifts.dart';

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
                        onPressed: () {},
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
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.event,
                                    color: theme.colorScheme.surface,
                                  ),
                                  title: Text(
                                    event.eventName,
                                    style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd-MM-yyyy HH:mm')
                                        .format(event.dateTime),
                                    style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GiftManagement(event: event)));
                                  },
                                ),
                              ),
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: gifts.length ?? 0,
                    // Use giftIds for itemCount
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items per row
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      childAspectRatio: 3, // Width to height ratio
                    ),
                    itemBuilder: (context, index) {
                      // Use giftIds for displaying items
                      final gift =
                          gifts[index] ?? "No gift found"; // Null-safe access
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.card_giftcard,
                            color: theme.colorScheme.surface,
                          ),
                          title: Text(
                            gift.giftName,
                            style: TextStyle(
                              color: theme.colorScheme.surface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            gift.isPledged ? "Pledged" : "Not pledged",
                            style: TextStyle(
                                color: gift.isPledged
                                    ? Colors.orangeAccent
                                    : Colors.grey[300]),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GiftSettings(gift: gift)));
                          },
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
