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

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> futureData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<dynamic> allFriends = [];
  List<dynamic> filteredFriends = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureData = MyFriendsViewModel().initialiseData();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'appBarTitle',
          child: Material(
            color: Colors.transparent,
            child: Text('Hedieaty', style: theme.appBarTheme.titleTextStyle),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFriend(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Card(
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
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value.toLowerCase();
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 0, 0, 10),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.search,
                                    color: theme.colorScheme.primary,
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
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Center(
                                child: Text("No friends data available"));
                          }
                          List friends = (snapshot.data!['friends'] as List)
                              .map((e) => e)
                              .toList();
                          debugPrint(
                              'Friends List: $friends'); // Check if friends data is correct
                          // allFriends = friends; // Store all friends
                          // filteredFriends =
                          //friends; // Initialize filtered list with all friends
                          friends = MyFriendsViewModel()
                              .applySearch(friends, searchQuery);

                          return ListView.builder(
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(
                                      index * 0.1,
                                      1.0,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 3),
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
                                      ),
                                      subtitle: Text(
                                        '${friend.eventIds.length > 0 ? friend.eventIds.length : "No"} upcoming event${friend.eventIds.length == 1 ? "" : "s"}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      onTap: () async {
                                        final variable = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfile(friend: friend),
                                          ),
                                        );
                                        if (variable == true) {
                                          setState(() {
                                            futureData = MyFriendsViewModel()
                                                .initialiseData();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
