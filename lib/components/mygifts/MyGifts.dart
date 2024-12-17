import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/mygifts/MyGiftsVM.dart';
import '../giftsettings/GiftSettings.dart';

class MyGiftsPage extends StatefulWidget {
  @override
  State<MyGiftsPage> createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  late Future<Map<String, dynamic>> futureData;
  String searchQuery = "";
  String selectedSort = "Name";
  String selectedFilter = "All";

  @override
  void initState() {
    futureData = MyGiftsViewModel().initialiseData();
    super.initState();
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
          //Filter,Sort,Search
          //TODO
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Search Gifts",
                      prefixIcon: Icon(Icons.search,color: theme.colorScheme.primary,),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedSort,
                  items: ["Name", "Price", "Category"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSort = newValue!;
                    });
                  },
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ["All", "Not Pledged", "Pledged"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
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
                List gifts =
                    (snapshot.data!['gifts'] as List).map((e) => e).toList();

                gifts = MyGiftsViewModel().applyFiltersAndSort(
                    gifts, searchQuery, selectedSort, selectedFilter);

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: gifts.length,
                    itemBuilder: (context, index) {
                      final gift = gifts[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            border: Border.all(
                              width: 2,
                              color: gift.isPledged
                                  ? theme.colorScheme.primary
                                  : Colors.orangeAccent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: gift.isPledged? theme.colorScheme.primary: Colors.orange[200],
                                child: CircleAvatar(
                                  radius: 40, // Slightly larger avatar
                                  backgroundImage: AssetImage(
                                          gift.image ?? "assets/default_gift.png")
                                      as ImageProvider,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gift.giftName,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF292f36),
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Category: ${gift.category.toString().split('.').last}",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF292f36),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Price: \$${gift.price}",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF292f36),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Description:\n${gift.description}",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF292f36),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Status: ${gift.isPledged ? "Pledged" : "Not Pledged"}",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w500,
                                          color: gift.isPledged
                                              ? Colors.green
                                              : Colors.orangeAccent,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: ()async {
                                   final variable=await  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GiftSettings(gift: gift)));
                                   if(variable==true){
                                     setState(() {
                                       futureData=MyGiftsViewModel().initialiseData();
                                     });
                                   }
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                gift.isPledged
                                    ? Icons.check_circle
                                    : Icons.pending,
                                color: gift.isPledged
                                    ? Colors.green
                                    : Colors.orangeAccent,
                                size: 30,
                              ),
                            ],
                          ),
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
