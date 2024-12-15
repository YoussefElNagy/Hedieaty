import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/events.dart';
import '../model/gifts.dart';
import 'GiftDetails.dart'; // Assuming this is where the Gift model/data resides

class EventDetails extends StatelessWidget {
  final Event event;

  EventDetails({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of gifts
    List<Gift> allGifts = [
      // Gifts for Wedding Event (id: 1)
      Gift(
        id: '1',
        giftName: 'Smartphone',
        description: 'A latest model smartphone with high-end features.',
        price: 699.99,
        image: 'assets/images/smartphone.png',
        ownerId: 'user123',
        isPledged: false,
        category: GiftCategory.electronics,
        eventId: '1',
      ),
      Gift(
        id: '2',
        giftName: 'Wedding Ring',
        description: 'A beautiful engagement ring with a diamond.',
        price: 999.99,
        image: 'assets/images/ring.png',
        ownerId: 'user124',
        isPledged: true,
        pledgedById: 'user456',
        category: GiftCategory.clothing,
        eventId: '1',
      ),

      // Gifts for Birthday Event (id: 2)
      Gift(
        id: '3',
        giftName: 'Wireless Headphones',
        description: 'Noise-cancelling over-ear headphones.',
        price: 199.99,
        image: 'assets/images/headphones.png',
        ownerId: 'user123',
        isPledged: true,
        pledgedById: 'user456',
        category: GiftCategory.electronics,
        eventId: '2',
      ),
      Gift(
        id: '4',
        giftName: 'Personalized Mug',
        description: 'A mug with a custom name and design.',
        price: 19.99,
        image: 'assets/images/mug.png',
        ownerId: 'user789',
        isPledged: false,
        category: GiftCategory.home,
        eventId: '2',
      ),

      // Gifts for Graduation Event (id: 3)
      Gift(
        id: '5',
        giftName: 'Designer Jacket',
        description: 'Stylish and warm jacket for winter.',
        price: 120.00,
        image: 'assets/images/jacket.png',
        ownerId: 'user789',
        isPledged: true,
        pledgedById: 'user123',
        category: GiftCategory.clothing,
        eventId: '3',
      ),
      Gift(
        id: '6',
        giftName: 'Laptop Bag',
        description: 'High-quality laptop bag with compartments.',
        price: 49.99,
        image: 'assets/images/laptop_bag.png',
        ownerId: 'user456',
        isPledged: false,
        category: GiftCategory.clothing,
        eventId: '3',
      ),

      // Gifts for Eid Event (id: 4)
      Gift(
        id: '7',
        giftName: 'Toy Car',
        description: 'Remote-controlled toy car with LED lights.',
        price: 49.99,
        image: null, // No image provided
        ownerId: 'user123',
        isPledged: false,
        category: GiftCategory.toys,
        eventId: '4',
      ),
      Gift(
        id: '8',
        giftName: 'Perfume Set',
        description: 'Luxury perfume set with various scents.',
        price: 59.99,
        image: 'assets/images/perfume.png',
        ownerId: 'user567',
        isPledged: false,
        category: GiftCategory.other,
        eventId: '4',
      ),

      Gift(
        id: '9',
        giftName: 'Nognog Teddy Bear',
        description: 'A small teddy bear.',
        price: 22199.99,
        image: 'assets/images/smartwatch.png',
        ownerId: '3',
        isPledged: false,
        category: GiftCategory.toys,
        eventId: '10',
      ),
      Gift(
        id: '10',
        giftName: 'Wedding Gift Box',
        description: 'A special box with chocolates, candles, and love notes.',
        price: 59.99,
        image: 'assets/images/gift_box.png',
        ownerId: 'user124',
        isPledged: true,
        pledgedById: 'user789',
        category: GiftCategory.home,
        eventId: '5',
      ),

      // Gifts for Birthday Event (id: 6)
      Gift(
        id: '11',
        giftName: 'Blender',
        description: 'High-speed blender for making smoothies.',
        price: 89.99,
        image: 'assets/images/blender.png',
        ownerId: 'user456',
        isPledged: false,
        category: GiftCategory.home,
        eventId: '6',
      ),
      Gift(
        id: '12',
        giftName: 'Fitness Tracker',
        description: 'A fitness tracker to monitor health and activity.',
        price: 79.99,
        image: 'assets/images/fitness_tracker.png',
        ownerId: 'user567',
        isPledged: true,
        pledgedById: 'user789',
        category: GiftCategory.electronics,
        eventId: '6',
      ),

      // Gifts for 3enaba Event (id: 7)
      Gift(
        id: '13',
        giftName: 'Laptop Sleeve',
        description: 'Protective sleeve for laptops, padded and stylish.',
        price: 29.99,
        image: 'assets/images/laptop_sleeve.png',
        ownerId: 'user789',
        isPledged: false,
        category: GiftCategory.electronics,
        eventId: '7',
      ),
      Gift(
        id: '14',
        giftName: 'Speaker Set',
        description: 'A set of portable wireless speakers.',
        price: 129.99,
        image: 'assets/images/speakers.png',
        ownerId: 'user123',
        isPledged: true,
        pledgedById: 'user456',
        category: GiftCategory.electronics,
        eventId: '7',
      ),

      // Gifts for Mehalabeya Event (id: 8)
      Gift(
        id: '15',
        giftName: 'Gift Voucher',
        description: 'A gift voucher for a local store.',
        price: 50.00,
        image: 'assets/images/voucher.png',
        ownerId: 'user789',
        isPledged: false,
        category: GiftCategory.other,
        eventId: '8',
      ),
      Gift(
        id: '16',
        giftName: 'Hammam Set',
        description: 'A traditional Hammam set with oils and scents.',
        price: 69.99,
        image: 'assets/images/hammam_set.png',
        ownerId: 'user123',
        isPledged: true,
        pledgedById: 'user456',
        category: GiftCategory.clothing,
        eventId: '8',
      ),
    ];

    // Filter gifts for the current event
    List<Gift> eventGifts =
        allGifts.where((gift) => gift.eventId == event.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hedieaty",
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Information Section
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 4
                  ),
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${event.ownerId}'s ${event.eventName}",
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Category: ${event.category.name}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gift List Section
            Text(
              'Gifts for this Event:',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: eventGifts.isEmpty
                  ? Center(
                      child: Text(
                        'No gifts added yet.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: eventGifts.length,
                      itemBuilder: (context, index) {
                        Gift gift = eventGifts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              gift.image ?? 'assets/default_gift.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/default_gift.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            title: Text(gift.giftName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${gift.category.name}'),
                                Text(
                                    'Price: \$${gift.price.toStringAsFixed(2)}'),
                                Text('Description: ${gift.description}'),
                                Text(
                                  'Status: ${gift.isPledged?"Pledged":"Available"}',
                                  style: TextStyle(
                                    color: gift.isPledged? Colors.orange
                                        : Colors.green
                                  ),
                                ),
                              ],
                            ),
                            trailing: gift.isPledged
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.pending_actions,
                                    color: Colors.grey),
                            isThreeLine: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GiftDetails(gift: gift),
                                  ),
                                );
                              }),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
