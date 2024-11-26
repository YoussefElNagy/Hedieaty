import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/data/events.dart';
import '../data/users.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

User currentUser = User(
    username: "Nognog",
    upcomingEvents: 2,
    profilePic: "default_avatar.png",
    phoneNumber: "+201093255558",
    email: "nognog@nognog.com",
    events: [
      Event(
        eventName: "Wedding",
        owner: "HamadaBelGanzabeel",
        dateTime: DateTime(2024, 12, 5, 10, 0),
        category: "Wedding",
        status: "Upcoming",
      ),
      Event(
        eventName: "Birthday",
        owner: "Nognog",
        dateTime: DateTime(2024, 11, 25, 18, 30),
        category: "Entertainment",
        status: "Upcoming",
      ),
      Event(
        eventName: "Graduation",
        owner: "HappyTheAir",
        dateTime: DateTime(2025, 12, 5, 10, 0),
        category: "Graduation",
        status: "Upcoming",
      ),
      Event(
        eventName: "Eid",
        owner: "EidSaeedRamadan",
        dateTime: DateTime(2024, 11, 25, 18, 30),
        category: "Eid",
        status: "Upcoming",
      ),
    ],
    gifts: [
      'Gift 1',
      'Gift 2',
      'Gift 3',
    ]);

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                  'assets/sample.jpg', // Replace with your image path
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                // Apply the blur effect using BackdropFilter
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5), // Adjust blur strength
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withOpacity(0), // Optional: for maintaining color overlay
                  ),
                ),
                // Profile image (circle avatar)
                Positioned(
                  top: 100, // Adjust position for the profile image
                  child: CircleAvatar(
                    radius: 50, // Profile image size
                    backgroundColor: Colors.white, // Background color of the circle
                    backgroundImage: AssetImage('assets/sample.jpg'), // Your profile pic
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Username and Email
            Text(
              currentUser.username, // Replace with dynamic username
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            Text(
              currentUser.email, // Replace with dynamic email
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
                      color: theme.colorScheme.onPrimary, // Text color matching button background
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
                  onPressed: () {},
                  child: Text(
                    'Pledged Gifts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary, // Text color matching button background
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

            // Display Events List
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  // List of events
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevents scrolling inside the ListView
                    itemCount: currentUser.events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            border: Border.all(color: theme.colorScheme.primary,width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.event,color:theme.colorScheme.surface ,),
                            title: Text(currentUser.events[index].eventName,style: TextStyle(color: theme.colorScheme.surface,fontWeight: FontWeight.w700),),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Display Gifts List
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Gifts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,

                    ),
                  ),
                  SizedBox(height: 10),
                  // List of pledged gifts
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevents scrolling inside the ListView
                    itemCount: currentUser.gifts!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        child: Container(
                            decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            border: Border.all(color: theme.colorScheme.primary,width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                            ),
                          child: ListTile(
                            leading: Icon(Icons.card_giftcard,color:theme.colorScheme.surface ,),
                            title: Text(currentUser.gifts![index],style: TextStyle(color: theme.colorScheme.surface,fontWeight: FontWeight.w700),),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
