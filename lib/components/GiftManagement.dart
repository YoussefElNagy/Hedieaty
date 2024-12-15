import 'package:flutter/material.dart';
import '../model/events.dart'; // Assuming you have Event and Gift models
import '../model/gifts.dart';
import 'GiftSettings.dart'; // Import the gifts data model

class GiftManagement extends StatefulWidget {
  final Event event;

  const GiftManagement({Key? key, required this.event}) : super(key: key);

  @override
  _GiftManagementState createState() => _GiftManagementState();
}

class _GiftManagementState extends State<GiftManagement> {
  @override
  Widget build(BuildContext context) {
    // Here, `event.giftIds` should be the list of IDs of gifts associated with the event
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.event.eventName} Gifts',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.event.giftIds.length,
        itemBuilder: (context, index) {
          final giftId = widget.event.giftIds[index];
          final gift = getGiftById(
              giftId); // This should fetch the gift data from your source

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GiftSettings(gift: gift)),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
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
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Spacing between image and text
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
                                TextOverflow.ellipsis, // Prevent text overflow
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
                            'Category: ${gift.category.name}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a form to add a new gift to this event
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddGiftPage(event: widget.event)),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // Example function to retrieve gift details (replace with your data access logic)
  Gift getGiftById(String id) {
    // Replace this with the actual logic to fetch gift by ID from a data source or API
    return Gift(
      id: '6',
      giftName: 'Shay Belaban',
      description: 'Lovely tea for lovely Nog',
      price: 100000.0,
      image: 'assets/default_gift.png',
      ownerId: '1',
      pledgedById: null,
      isPledged: false,
      category: GiftCategory.toys,
      eventId: '3',
    );
  }

  // Example function for gift deletion
  void deleteGift(String giftId) {
    // Here, we should remove the gift from the event's list and update the UI
    setState(() {
      widget.event.giftIds.remove(giftId);
    });
    // Additional logic can be added to persist the deletion (e.g., updating a database or API)
    print("Gift with id: $giftId has been deleted.");
  }
}

class AddGiftPage extends StatefulWidget {
  final Event event;

  const AddGiftPage({Key? key, required this.event}) : super(key: key);

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController giftNameController = TextEditingController();
    final TextEditingController giftPriceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hedieaty',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: giftNameController,
              decoration: const InputDecoration(labelText: 'Gift Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: giftPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final giftName = giftNameController.text;
                final giftPrice =
                    double.tryParse(giftPriceController.text) ?? 0;

                // Add the new gift
                final newGift = Gift(
                  id: DateTime.now().toString(),
                  giftName: giftName,
                  description: 'New gift description',
                  price: giftPrice,
                  image:
                      'https://example.com/newgift.jpg', // Set the image as required
                  ownerId: widget.event.ownerId,
                  pledgedById: null,
                  isPledged: false,
                  category: GiftCategory.other,
                  eventId: widget.event.id,
                );
                // Add the new gift to the event's gift list
                widget.event.giftIds.add(newGift.id);
                // Notify the parent widget to update the state
                Navigator.pop(context);
              },
              child: Text(
                'Add Gift',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
