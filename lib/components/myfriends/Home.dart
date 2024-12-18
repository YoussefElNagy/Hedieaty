import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/addfriend/AddFriend.dart';
import 'package:hedeyeti/components/myfriends/MyFriendsVM.dart';
import 'FriendProfile.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> futureData;
  TextEditingController searchController = TextEditingController();
  List<dynamic> allFriends = [];
  List<dynamic> filteredFriends = [];

  void _filterFriends() {
    debugPrint('Search query: ${searchController.text}'); // Debugging line
    setState(() {
      filteredFriends = allFriends.where((friend) {
        return friend.username
            .toLowerCase()
            .contains(searchController.text.toLowerCase()) ||
            (friend.email != null &&
                friend.email!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()));
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    futureData = MyFriendsViewModel().initialiseData();
    searchController.addListener(_filterFriends);  // Add listener to search controller
  }
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFriend()));
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
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: "Search for a friend..",
                                  labelStyle: TextStyle(
                                      color: theme.colorScheme.primary),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary, // Primary Teal border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary, // Primary Teal border when focused
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (_) {_filterFriends();},
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(15.0, 0, 0, 10),
                              child: IconButton(
                                onPressed: _filterFriends,
                                icon: Icon(
                                  Icons.search,
                                  color: theme.colorScheme.primary, // Primary Teal search icon color
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
                    child: FutureBuilder(
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
                        final friends = snapshot.data!['friends'];
                        debugPrint('Friends List: ${friends}');  // Check if friends data is correct
                        allFriends = friends;  // Store all friends
                        filteredFriends = friends;  // Initialize filtered list with all friends
                        return ListView.builder(

                          itemCount: filteredFriends.length,
                          itemBuilder: (context, index) {
                            final friend=filteredFriends[index];
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                              child: Card(
                                color: Color(0xFFFAFAFA),
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    friend.username,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        friend.profilePic ??
                                            "assets/default_avatar.png"),
                                    // onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
                                  ),
                                  subtitle: Text(
                                      '${friend.eventIds.length > 0
                                          ? friend.eventIds.length
                                          : "No"} upcoming event${friend
                                          .eventIds.length == 1 ? "" : "s"}',
                                      style: theme.textTheme.bodyMedium),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfile(
                                                    friend: friend)));
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
