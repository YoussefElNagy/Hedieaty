import 'package:flutter/material.dart';
import 'package:hedeyeti/components/mygifts/MyGiftsVM.dart';
import '../../model/events.dart'; // Assuming you have Event and Gift models
import '../addgift/AddGift.dart';
import '../giftsettings/GiftSettings.dart'; // Import the gifts data model

class GiftManagement extends StatefulWidget {
  final Event event;

  const GiftManagement({Key? key, required this.event}) : super(key: key);

  @override
  _GiftManagementState createState() => _GiftManagementState();
}

class _GiftManagementState extends State<GiftManagement> {
  late Future<Map<String, dynamic>> futureData;
  String searchQuery = "";
  String selectedSort = "Name";
  String selectedFilter = "All";

  @override
  void initState() {
    futureData= MyGiftsViewModel().initialiseEventData(widget.event.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.event.eventName} Gifts',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [

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
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return InkWell(
                    onTap: () async{
                      final variable = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiftSettings(gift: gift)),
                      );
                      if(variable==true){
                        setState(() {
                          futureData=MyGiftsViewModel().initialiseEventData(widget.event.id);
                        });
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16,
                          vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: gift.isPledged? theme.colorScheme.tertiary: Colors.orange[100],
                          border: Border.all(
                            width: 2,
                            color: gift.isPledged
                                ? theme.colorScheme.primary
                                : Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Image with fixed dimensions and constrained size
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 80, // Constrained width
                                  height: 80, // Constrained height
                                  child: Image.asset(
                                    gift.image ?? 'assets/default_gift.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(
                                          Icons.broken_image,
                                          color: Colors.grey[400],
                                          size: 50,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Spacing between image and text
                              // Flexible content to prevent overflow
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gift.giftName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow:
                                      TextOverflow
                                          .ellipsis, // Prevent text overflow
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Price: \$${gift.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Category: ${gift.category.toString().split('.').last}',
                                      style:  TextStyle(
                                        fontSize: 14,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${gift.description}',
                                      style:  TextStyle(
                                          fontSize: 14,
                                          color: theme.colorScheme.secondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          // Navigate to a form to add a new gift to this event
          final variable = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddGiftPage(event: widget.event)),
          );
          if(variable==true){
            setState(() {
              futureData=MyGiftsViewModel().initialiseEventData(widget.event.id);
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

