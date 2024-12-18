import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/giftdetails/GiftDetails.dart';
import 'package:hedeyeti/components/pledgedgifts/PledgedGiftsViewModel.dart';

class PledgedGiftsPage extends StatefulWidget {
  final String currentUserId; // Pass current user's ID

  PledgedGiftsPage({required this.currentUserId});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  late Future<Map<String, dynamic>> futureData;
  String searchQuery = "";
  String selectedSort = "Name";
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    futureData = PledgedGiftsViewModel().initialiseData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pledged Gifts',
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
                      labelText: "Search Gifts",
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<String>(
                    value: selectedSort,
                    icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    items: ["Name", "Price"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSort = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading data"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No events available"));
                }
                List pledgedGifts = (snapshot.data!['pledgedGifts'] as List)
                    .map((e) => e)
                    .toList();

                pledgedGifts = PledgedGiftsViewModel().applyFiltersAndSort(
                    pledgedGifts, searchQuery, selectedSort, selectedFilter);

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: pledgedGifts.length,
                    itemBuilder: (context, index) {
                      final gift = pledgedGifts[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.colorScheme.primary,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(
                                  gift.image ?? "assets/default_img.png",
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gift.giftName,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.surface,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Category: ${gift.category.toString().split('.').last} \nPrice: \$${gift.price}",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.surface,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final variable = Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GiftDetails(gift: gift)));
                                        if (variable == true) {
                                          setState(() {
                                            futureData = PledgedGiftsViewModel()
                                                .initialiseData();
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_sharp,
                                        color: theme.colorScheme.tertiary,
                                        size: 30,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
