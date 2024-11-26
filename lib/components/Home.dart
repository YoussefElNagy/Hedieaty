import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/users.dart';

class Home extends StatefulWidget {

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<User> myFriends = [
    User(username: "SnoopNogg69", upcomingEvents: 2, profilePic: "default_avatar.png", phoneNumber: "+201093255558",email: "snoop@nogg.com",events: []),
    User(username: "CristianoRonaldoooooo", upcomingEvents: 6,  phoneNumber: "+201093255558",email: "suii@suii.com",events: []),
    User(username: "Buk@yoS@k@", upcomingEvents: 0,  phoneNumber: "+201077777777",email: "saka@bukyo.com",events: []),
    User(username: "HappyTheAir", upcomingEvents: 2,  phoneNumber: "+201012345678",email: "abaja@slsss.com",events: []),
    User(username: "Ghost", upcomingEvents: 0,  phoneNumber: "+201000000000",email: "abc@abc.com",events: []),
    User(username: "EidSaeedRamadan", upcomingEvents: 19, phoneNumber: "+201007775000",email: "shha@aaaa.com",events: []),
    User(username: "NourElFouad", upcomingEvents: 1, phoneNumber: "+201012344045",email: "aaaaa@nogg.com",events: []),
    User(username: "HamadaBelGanzabeel", upcomingEvents: 3, phoneNumber: "+201094574821",email: "abcde@nogg.com",events: []),
    User(username: "ItsMeBolbol", upcomingEvents: 0,  phoneNumber: "+201090008000",email: "bala7@belaban.com",events: []),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hedieaty',
          style:
          GoogleFonts.cairo(fontSize: 30), // Google Font for AppBar title
        ),
        centerTitle: true,
      ),
      body: Stack(
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
                                  labelText: "Search for a friend..",
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
                                backgroundImage: AssetImage('assets/default_avatar.png'),
                                // onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
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
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Your action here
        },
        child: Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
