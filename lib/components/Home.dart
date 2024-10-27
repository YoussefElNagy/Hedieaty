import 'package:flutter/material.dart';
import '../data/friends.dart';

class Home extends StatelessWidget {
  final List<Friend> myFriends = [
    Friend(username: "SnoopNogg69", upcomingEvents: 2, profilePic: "default_avatar.png", phoneNumber: "+201093255558",events: []),
    Friend(username: "CristianoRonaldoooooo", upcomingEvents: 6, profilePic: "nog.jpg", phoneNumber: "+201093255558",events: []),
    Friend(username: "Buk@yoS@k@", upcomingEvents: 0, profilePic: "buk.jpg", phoneNumber: "+201077777777",events: []),
    Friend(username: "HappyTheAir", upcomingEvents: 2, profilePic: "snoop.jpg", phoneNumber: "+201012345678",events: []),
    Friend(username: "Ghost", upcomingEvents: 0, profilePic: "nog.jpg", phoneNumber: "+201000000000",events: []),
    Friend(username: "EidSaeedRamadan", upcomingEvents: 19, profilePic: "buk.jpg", phoneNumber: "+201007775000",events: []),
    Friend(username: "NourElFouad", upcomingEvents: 1, profilePic: "snoop.jpg", phoneNumber: "+201012344045",events: []),
    Friend(username: "HamadaBelGanzabeel", upcomingEvents: 3, profilePic: "nog.jpg", phoneNumber: "+201094574821",events: []),
    Friend(username: "ItsMeBolbol", upcomingEvents: 0, profilePic: "buk.jpg", phoneNumber: "+201090008000",events: []),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                // Search Bar
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                            width: 240,
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10), // Padding inside the TextField
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary, // Border color when not active
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary, // Border color when active
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                            child: IconButton(
                              onPressed: () {
                                // Your search action here
                              },
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFF4ecdc4),
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Divider
                Divider(color: Color(0XFFBEEFEB), height: 5),

                // Friends List
                Expanded(
                  child: ListView.builder(
                    itemCount: myFriends.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                        child: Card(
                          color: Color(0xFFFAFAFA),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              myFriends[index].username,
                              style: theme.textTheme.bodyLarge,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/${myFriends[index].profilePic}'),
                              onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
                            ),
                            subtitle: myFriends[index].upcomingEvents == 0
                                ? Text("No upcoming events", style: theme.textTheme.bodySmall)
                                : Text('${myFriends[index].upcomingEvents} upcoming events', style: theme.textTheme.bodySmall),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button
        Positioned(
          bottom: 16,
          right: MediaQuery.of(context).size.width / 2 - 180, // Center the button horizontally
          child: FloatingActionButton(
            onPressed: () {
              // Your action here
            },
            child: Icon(Icons.add),
            backgroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
