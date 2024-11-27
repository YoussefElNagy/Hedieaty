import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/events.dart';
import '../data/users.dart';

class FriendProfile extends StatefulWidget {
  final User friend;

  FriendProfile({required this.friend});

  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    final friend= widget.friend;
    final theme = Theme.of(context);

    final List<Event> friendEvents = [
      Event(
        id: "1",
        eventName: "Wedding",
        ownerId: "8", // ID of "HamadaBelGanzabeel"
        dateTime: DateTime(2024, 12, 5, 10, 0),
        category: EventCategory.wedding,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "2",
        eventName: "Birthday",
        ownerId: "10", // ID of "Nognog"
        dateTime: DateTime(2025, 07, 23, 18, 30),
        category: EventCategory.birthday,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "3",
        eventName: "Graduation",
        ownerId: "4", // ID of "HappyTheAir"
        dateTime: DateTime(2025, 12, 5, 10, 0),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "4",
        eventName: "Eid",
        ownerId: "6", // ID of "EidSaeedRamadan"
        dateTime: DateTime(2024, 11, 25, 18, 30),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "5",
        eventName: "Wedding",
        ownerId: "4", // ID of "HappyTheAir"
        dateTime: DateTime(2024, 12, 5, 10, 0),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "6",
        eventName: "Birthday",
        ownerId: "4", // ID of "HappyTheAir"
        dateTime: DateTime(2024, 12, 19, 10, 0),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "7",
        eventName: "3enaba",
        ownerId: "7", // ID of "HappyTheAir"
        dateTime: DateTime(2028, 10, 30, 20, 10),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
      Event(
        id: "8",
        eventName: "Mehalabeya",
        ownerId: "2", // ID of "HappyTheAir"
        dateTime: DateTime(2090, 1, 1, 23, 50),
        category: EventCategory.other,
        status: EventStatus.active,
        giftIds: [],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.username,style: TextStyle(fontSize: 30)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_remove,color: Colors.red,), // Icon for unfriend button
            onPressed: () {
              print('Unfriended ${friend.username}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Background Image as a Stack (simulating a background for the profile)
            Stack(
              alignment: Alignment.center,
              children: [
                // Background image with blur effect
                Image.asset(
                  friend.profilePic ?? 'assets/sample.jpg', // Use a placeholder if null
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
                // Profile image (circle avatar)
                Positioned(
                  top: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                        friend.profilePic ?? 'assets/default.png'), // Use placeholder if null
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Username and Email
            // Text(
            //   friend.username ?? "Username", // Use a default if null
            //   style: TextStyle(
            //     fontSize: 36,
            //     fontWeight: FontWeight.bold,
            //     color: theme.colorScheme.secondary,
            //   ),
            // ),
            Text(
              friend.email ?? "No email provided", // Default if null
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${friend.friendIds.length} friend${friend.friendIds.length==1? "": "s"} ",style: theme.textTheme.bodyLarge,),
                Text("Wishlist: ${friend.giftIds?.length} gift${friend.friendIds.length==1? "": "s"}",style: theme.textTheme.bodyLarge),
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
                    itemCount: friendEvents.length,
                    itemBuilder: (context, index) {
                      final event = friendEvents[index];
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
              'Wishlist',
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: friend.giftIds?.length ?? 0, // Use giftIds for itemCount
              itemBuilder: (context, index) {
                // Use giftIds for displaying items
                final gift = friend.giftIds?[index] ?? "No gift found"; // Null-safe access
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 18),

                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,16,0),
                              child: Icon(
                                Icons.card_giftcard,
                                color: theme.colorScheme.surface,
                              ),
                            ),
                            Text(
                              gift,
                              style: TextStyle(
                                color: theme.colorScheme.surface,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevent overflow
                              maxLines: 1, // Limit to 1 line
                            ),
                          ],
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "Placeholder for Event Name", // Replace with actual event name
                            style: TextStyle(
                              color: theme.colorScheme.tertiary,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Pledge',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
