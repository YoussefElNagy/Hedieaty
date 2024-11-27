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
    User(
      id: "1",
      username: "SnoopNogg69",
      email: "snoop@nogg.com",
      profilePic: "assets/default_avatar.png",
      phoneNumber: "+201093255558",
      isEmailVerified: true,
      eventIds: ['1','2','3'],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "2",
      username: "CristianoRonaldoooooo",
      email: "suii@suii.com",
      profilePic: "assets/default_avatar.png",
      phoneNumber: "+201093255558",
      isEmailVerified: true,
      eventIds: ['11','22','33'],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "3",
      username: "Buk@yoS@k@",
      email: "saka@bukyo.com",
      profilePic: "assets/default_avatar.png",
      phoneNumber: "+201077777777",
      isEmailVerified: true,
      eventIds: [],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "4",
      username: "HappyTheAir",
      profilePic: "assets/default_avatar.png",
      email: "abaja@slsss.com",
      phoneNumber: "+201012345678",
      isEmailVerified: true,
      eventIds: ['111','21','13','123'],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "5",
      username: "Sword",
      email: "seif@seif.com",
      profilePic: "assets/default_avatar.png",
      phoneNumber: "+201000000000",
      isEmailVerified: false,
      eventIds: ['9'],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "6",
      username: "EidSaeedRamadan",
      email: "shha@aaaa.com",
      profilePic: "assets/default_avatar.png",
      phoneNumber: "+201007775000",
      isEmailVerified: false,
      eventIds: [],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "7",
      username: "NourElFouad",
      email: "aaaaa@nogg.com",
      phoneNumber: "+201012344045",
      isEmailVerified: true,
      eventIds: [],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "8",
      username: "HamadaBelGanzabeel",
      email: "abcde@nogg.com",
      phoneNumber: "+201094574821",
      isEmailVerified: true,
      eventIds: [],
      giftIds: [],
      friendIds: [],
    ),
    User(
      id: "9",
      username: "ItsMeBolbol",
      email: "bala7@belaban.com",
      phoneNumber: "+201090008000",
      isEmailVerified: false,
      eventIds: ['5'],
      giftIds: [],
      friendIds: [],
    ),
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
                                backgroundImage: AssetImage(myFriends[index].profilePic??"assets/default_avatar.png"),
                                // onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
                              ),
                              subtitle: myFriends[index].eventIds.length == 0
                                  ? Text("No upcoming events", style: theme.textTheme.bodyMedium)
                                  : Text('${myFriends[index].eventIds.length} upcoming events', style: theme.textTheme.bodyMedium),
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
