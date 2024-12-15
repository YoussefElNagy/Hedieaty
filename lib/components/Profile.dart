import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/users.dart';
import '../data/events.dart';
import 'PledgedGifts.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

UserModel currentUser = UserModel(
  id: "1", // Assuming an ID for the user, as it's required in the User class
  username: "Nognog",
  email: "nognog@nognog.com",
  profilePic: "assets/sample.jpg", // Default value, use a placeholder if null
  phone: "+201093255558",
  eventIds: [
    "2", // Event ID for "Wedding"
    "3", // Event ID for "Birthday"
    "4", // Event ID for "Graduation"
    "5", // Event ID for "Eid"
  ],
  giftIds: [
    'Gift 1',
    'Gift 2',
    'Gift 3',
    'Gift 4',
  ],
  pledgedGiftIds: [
    'Gift 1',
    'Gift 2',
    'Gift 3',
    'Gift 4',
    'Gift 5',
    'Gift 6',
    'Gift 7',
    'Gift 8'
  ],
  friendIds: ['4','9','66','5','6','9'],
);

// Events corresponding to the above user ID (using event IDs to associate the events)
final List<Event> events = [
  Event(
    id: "2", // Event ID for "Wedding"
    eventName: "Wedding",
    ownerId: "8", // ID of "HamadaBelGanzabeel"
    dateTime: DateTime(2024, 12, 5, 10, 0),
    category: EventCategory.wedding,
    giftIds: [],
  ),
  Event(
    id: "3", // Event ID for "Birthday"
    eventName: "Birthday Albi",
    ownerId: "10", // ID of "Nognog"
    dateTime: DateTime(2024, 11, 25, 18, 30),
    category: EventCategory.entertainment,
    giftIds: [],
  ),
  // Event(
  //   id: "4", // Event ID for "Graduation"
  //   eventName: "Graduation",
  //   ownerId: "4", // ID of "HappyTheAir"
  //   dateTime: DateTime(2025, 12, 5, 10, 0),
  //   category: EventCategory.graduation,
  //   status: EventStatus.upcoming,
  //   giftIds: [],
  // ),
  // Event(
  //   id: "5", // Event ID for "Eid"
  //   eventName: "Eid",
  //   ownerId: "6", // ID of "EidSaeedRamadan"
  //   dateTime: DateTime(2024, 11, 25, 18, 30),
  //   category: EventCategory.eid,
  //   status: EventStatus.upcoming,
  //   giftIds: [],
  // ),
];

class _ProfileState extends State<Profile> {
  // Fetching events for the current user based on eventIds
  List<Event> getUserEvents() {
    return events.where((event) => currentUser.eventIds.contains(event.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background image with blur effect
                Image.asset(
                  currentUser.profilePic ?? 'assets/default_avatar.png', // Use a placeholder if null
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
                    backgroundImage: AssetImage(
                        currentUser.profilePic ?? 'assets/default.png'), // Use placeholder if null
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Username and Email
            Text(
              currentUser.username,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            Text(
              currentUser.email,
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
                        builder: (context) => PledgedGiftsPage(currentUserId: currentUser.id),
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
                Text("${currentUser.friendIds.length} friend${currentUser.friendIds.length==1? "": "s"} ",style: theme.textTheme.bodyLarge,),
                Text("Wishlist: ${currentUser.giftIds?.length} gift${currentUser.friendIds.length==1? "": "s"}",style: theme.textTheme.bodyLarge),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Divider(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // List of events
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: getUserEvents().length,
                    itemBuilder: (context, index) {
                      final event = getUserEvents()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
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
                              DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime),
                              style: TextStyle(
                                  color: theme.colorScheme.surface,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Divider(
                color: theme.colorScheme.primary,
              ),
            ),
            // List of gifts
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: currentUser.giftIds?.length ?? 0, // Use giftIds for itemCount
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
                childAspectRatio: 3, // Width to height ratio
              ),
              itemBuilder: (context, index) {
                // Use giftIds for displaying items
                final gift = currentUser.giftIds?[index] ?? "No gift found"; // Null-safe access
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.card_giftcard,
                      color: theme.colorScheme.surface,
                    ),
                    title: Text(
                      gift,
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
