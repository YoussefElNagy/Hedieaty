import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/services/users_service.dart';
import '../data/users.dart';
import 'FriendProfile.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<UserModel> myFriends = [
    UserModel(
      id: "1",
      username: "SnoopNogg69",
      email: "snoop@nogg.com",
      profilePic: "assets/default_avatar.png",
      phone: "+201093255558",
      eventIds: ['1', '2', '3'],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "2",
      username: "AlragolAl3onab",
      email: "3enaby@3enabak.com",
      profilePic: "assets/default_avatar.png",
      phone: "+201003255558",
      eventIds: ['11', '22', '33'],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "3",
      username: "Julie",
      email: "julie@shobrawy.com",
      profilePic: "assets/sample.jpg",
      phone: "+201077777777",
      eventIds: [],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "4",
      username: "HappyTheAir",
      profilePic: "assets/sample.jpg",
      email: "sa3eed@elhawa.com",
      phone: "+201012345678",
      eventIds: ['111', '21', '13', '123'],
      pledgedGiftIds: [],
      giftIds: ['1', '2'],
      friendIds: ['1', '2'],
    ),
    UserModel(
      id: "5",
      username: "Mehalabeya",
      email: "Mehalabeya@Mehalabeya.com",
      profilePic: "assets/default_avatar.png",
      phone: "+201000000000",
      eventIds: ['9'],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "6",
      username: "EidSaeedRamadan",
      email: "shha@aaaa.com",
      profilePic: "assets/default_avatar.png",
      phone: "+201007775000",
      eventIds: [],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "7",
      username: "AmiraBe7egabi",
      email: "aaaaa@nogg.com",
      phone: "+201012344045",
      eventIds: [],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "8",
      username: "HamadaBelGanzabeel",
      email: "abcde@nogg.com",
      phone: "+201094574821",
      eventIds: [],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(
      id: "9",
      username: "ItsMeBolbol",
      email: "bala7@belaban.com",
      phone: "+201090008000",
      eventIds: ['5'],
      pledgedGiftIds: [],
      friendIds: [],
    ),
    UserModel(id: "10", username: "Watermel0n", email: "watermelon@bateekh.com"),
    UserModel(id: "11", username: "MohamedMagdyAfsha", email: "afsha8545@qadeya.com"),
    UserModel(id: "11", username: "Mokattamawy", email: "OO@mokattam.com"),
    UserModel(id: "11", username: "Weeeeeeeee", email: "weeeee@nooo.com"),

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: theme.colorScheme.primary,
            ), // Icon for unfriend button
            onPressed: () {
              print('Add friend logic');
              UsersService().printUserFriends();  // Call this method to fetch and print the user data
            },
          ),
        ],
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
                                  labelStyle: TextStyle(
                                      color: theme.colorScheme.primary),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme
                                          .primary, // Primary Teal border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme
                                          .primary, // Primary Teal border when focused
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 0, 0, 10),
                              child: IconButton(
                                onPressed: () {
                                  // Your search action here
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: theme.colorScheme
                                      .primary, // Primary Teal search icon color
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                          child: Card(
                            color: Color(0xFFFAFAFA),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                myFriends[index].username,
                                style: theme.textTheme.bodyLarge,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                    myFriends[index].profilePic ??
                                        "assets/default_avatar.png"),
                                // onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
                              ),
                              subtitle: Text(
                                  '${myFriends[index].eventIds.length > 0 ? myFriends[index].eventIds.length : "No"} upcoming event${myFriends[index].eventIds.length == 1 ? "" : "s"}',
                                  style: theme.textTheme.bodyMedium),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FriendProfile(
                                            friend: myFriends[index])));
                              },
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
    );
  }
}
