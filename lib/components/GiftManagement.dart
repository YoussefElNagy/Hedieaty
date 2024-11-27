import 'package:flutter/material.dart';
import '../data/events.dart'; // Assuming you have Event and Gift models
import '../data/gifts.dart';  // Import the gifts data model

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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.event.giftIds.length,
        itemBuilder: (context, index) {
          final giftId = widget.event.giftIds[index];
          final gift = getGiftById(giftId); // This should fetch the gift data from your source

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(gift.giftName),
              subtitle: Text('Price: \$${gift.price.toString()}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteGift(gift.id); // Call the delete method
                },
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
            MaterialPageRoute(builder: (context) => AddGiftPage(event: widget.event)),
          );
        },
        child: const Icon(Icons.add),
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
      image: 'https://example.com/toyrobot.jpg',
      ownerId: '1',
      pledgedById: null,
      status: GiftStatus.available,
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

class AddGiftPage extends StatelessWidget {
  final Event event;

  const AddGiftPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController giftNameController = TextEditingController();
    final TextEditingController giftPriceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift'),
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
            TextField(
              controller: giftPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final giftName = giftNameController.text;
                final giftPrice = double.tryParse(giftPriceController.text) ?? 0;

                // Add the new gift
                final newGift = Gift(
                  id: DateTime.now().toString(),
                  giftName: giftName,
                  description: 'New gift description',
                  price: giftPrice,
                  image: 'https://example.com/newgift.jpg', // Set the image as required
                  ownerId: event.ownerId,
                  pledgedById: null,
                  status: GiftStatus.available,
                  isPledged: false,
                  category: GiftCategory.other,
                  eventId: event.id,
                );

                // Add the new gift to the event's gift list
                event.giftIds.add(newGift.id);

                // Notify the parent widget to update the state
                Navigator.pop(context);
              },
              child: const Text('Add Gift'),
            ),
          ],
        ),
      ),
    );
  }
}
