import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/addfriend/AddFriendVM.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  String searchQuery = "";
  String selectedSort = "Email";
  late Future<List> futureData = Future.value([]);
  final _viewModel = AddFriendViewModel();

  @override
  void initState() {
    super.initState();
    // Initial state with an empty Future.
    futureData = Future.value([]);
  }

  void fetchFriends() {
    setState(() {
      futureData = _viewModel.fetchFriendToAdd(searchQuery, selectedSort);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hedieaty',
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Find friends...",
                    ),
                    onChanged: (value) {
                      searchQuery = value.toLowerCase(); // Update query, but no fetch here
                    },
                  ),
                ),
                IconButton(
                  onPressed: fetchFriends, // Fetch friends only when button is pressed
                  icon: Icon(Icons.search, color: theme.primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                    value: selectedSort,
                    icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    items: ["Email", "Username"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSort = newValue!;
                        fetchFriends();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading data"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Search.."));
                }
                List users = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              user.username,
                              style: theme.textTheme.bodyLarge,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  user.profilePic ?? "assets/default_avatar.png"),
                            ),
                            subtitle: Text(user.email),
                            trailing: IconButton(onPressed: (){_viewModel.addFriend(user.id);}, icon: Icon(Icons.person_add,color: theme.colorScheme.secondary,)),
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
    );
  }
}
