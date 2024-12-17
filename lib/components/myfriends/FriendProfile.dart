import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hedeyeti/components/EventDetails.dart';
import 'package:hedeyeti/components/GiftDetails.dart';
import 'package:hedeyeti/components/myfriends/MyFriendsVM.dart';
import 'package:intl/intl.dart';

class FriendProfile extends StatefulWidget {
  final friend;

  FriendProfile({required this.friend});

  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    futureData = MyFriendsViewModel().initialiseFriendData(widget.friend.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final friend = widget.friend;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.username, style: TextStyle(fontSize: 30)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_remove,
              color: Colors.red,
            ), // Icon for unfriend button
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
                  friend.profilePic ??
                      'assets/sample.jpg', // Use a placeholder if null
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
                    backgroundImage: AssetImage(friend.profilePic ??
                        'assets/default.png'), // Use placeholder if null
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
              friend.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              "+2${friend.phone}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${friend.friendIds.length} friend${friend.friendIds.length == 1 ? "" : "s"} ",
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                    "Wishlist: ${friend.giftIds?.length} gift${friend.friendIds.length == 1 ? "" : "s"}",
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
                  FutureBuilder(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error loading data"));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text("No data available"));
                        }
                        final events = snapshot.data!['events'];
                        return ListView.builder(
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
                                  leading: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                      Icons.event,
                                      color: theme.primaryColor,
                                      size: 40,
                                    ),
                                  ),
                                  title: Text(
                                    event.eventName,
                                    style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          DateFormat('dd-MM-yyyy HH:mm')
                                              .format(event.dateTime),
                                          style: TextStyle(
                                              color: theme.colorScheme.surface,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: theme.colorScheme.primary,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            (event.location),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    theme.colorScheme.surface,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        final variable = Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetails(
                                                        event: event)));
                                        if (variable == true) {
                                          setState(() {
                                            futureData = MyFriendsViewModel()
                                                .initialiseFriendData(
                                                    widget.friend.id);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: theme.colorScheme.tertiary,
                                      )),
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
            FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading data"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("No data available"));
                  }
                  final events = snapshot.data!['events'];
                  final gifts = snapshot.data!['gifts'];

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: gifts.length ?? 0, // Use giftIds for itemCount
                    itemBuilder: (context, index) {
                      // Use giftIds for displaying items
                      final gift =
                          gifts[index] ?? "No gift found"; // Null-safe access
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            border: Border.all(
                                color: theme.colorScheme.primary, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 18),
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      child: CircleAvatar(
                                        radius: 34,
                                        backgroundImage: AssetImage(
                                          gift.image ??
                                              "assets/default_gift.png",
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    gift.giftName,
                                    style: TextStyle(
                                      color: theme.colorScheme.surface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent overflow
                                    maxLines: 1, // Limit to 1 line
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gift.description,
                                  // Replace with actual event name
                                  style: TextStyle(
                                    color: theme.colorScheme.tertiary,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      gift.isPledged
                                          ? "Pledged"
                                          : "Not Pledged",
                                      // Replace with actual event name
                                      style: TextStyle(
                                        color: gift.isPledged
                                            ? Colors.orange[200]
                                            : theme.colorScheme.tertiary,
                                        fontSize: 18,
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
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GiftDetails(gift: gift)));
                            },
                          ),
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
