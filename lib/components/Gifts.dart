import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/gifts.dart';

class GiftsPage extends StatefulWidget {
  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  final List<Gift> giftList = [
    Gift(
      id: '1',
      giftName: 'Smartphone',
      description: 'Latest model with high-end features.',
      price: 500.0,
      //image: 'https://example.com/smartphone.jpg', // Image URL or null
      ownerId: 'user123',
      pledgedById: null,
      status: GiftStatus.available,
      isPledged: false,
      category: GiftCategory.electronics,
      eventId: 'event1',
    ),
    Gift(
      id: '2',
      giftName: 'Designer Shirt',
      description: 'Stylish shirt with premium fabric.',
      price: 80.0,
      image: null, // No image, will use default
      ownerId: 'user456',
      pledgedById: 'user789',
      status: GiftStatus.pledged,
      isPledged: true,
      category: GiftCategory.clothing,
      eventId: 'event2',
    ),
    Gift(
      id: '3',
      giftName: 'Toy Robot',
      description: 'Interactive toy robot for kids.',
      price: 40.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.toys,
      eventId: 'event3',
    ),
    Gift(
      id: '4',
      giftName: 'Bed',
      description: 'Comfy bed.',
      price: 20000.0,
      image:
          'https://www.premierinnbed.co.uk/media/catalog/product/cache/215e62282d4b4b68400b8137e0654108/p/r/premierinn_mattress2.0_lilith_charcoal_gbtb_lifestyle_-_demand_gen_square.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.home,
      eventId: 'event3',
    ),
    Gift(
      id: '5',
      giftName: 'Toy Robot',
      description: 'Interactive toy robot for kids.',
      price: 40.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.toys,
      eventId: 'event3',
    ),
    Gift(
      id: '5',
      giftName: 'Dolphin',
      description: 'Interactive pet.',
      price: 40000.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.other,
      eventId: 'event3',
    ),
    Gift(
      id: '6',
      giftName: 'Shay Belaban',
      description: 'Lovely tea for lovely Nog',
      price: 100000.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'nognog',
      pledgedById: null,
      status: GiftStatus.available,
      isPledged: false,
      category: GiftCategory.toys,
      eventId: 'event3',
    ),
    Gift(
      id: '7',
      giftName: 'Legos',
      description: 'Interactive legos for kids.',
      price: 4410.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.toys,
      eventId: 'event3',
    ),
    Gift(
      id: '8',
      giftName: 'Sun Top',
      description: 'Incredible Juice, ORANGE.',
      price: 15.0,
      image: 'https://example.com/toyrobot.jpg',
      ownerId: 'user789',
      pledgedById: null,
      status: GiftStatus.delivered,
      isPledged: false,
      category: GiftCategory.other,
      eventId: 'event3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hedieaty',
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: giftList.isEmpty
          ? Center(
              child: Text(
                'No gifts available!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF292f36),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: giftList.length,
              itemBuilder: (context, index) {
                final gift = giftList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25, // Size of the avatar
                      backgroundImage: gift.image != null
                          ? NetworkImage(gift.image!) // If image exists, use it
                          : AssetImage('assets/default_gift.png')
                              as ImageProvider, // Default image if no image
                    ),
                    title: Text(
                      gift.giftName,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF292f36),
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Category: ${gift.category.toString().split('.').last} \nPrice: \$${gift.price}\nStatus: ${gift.status.toString().split('.').last}",
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF292f36),
                        fontSize: 14,
                      ),
                    ),
                    trailing: gift.isPledged
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.remove_circle, color: Colors.red),
                    onTap: () {
                      // Handle on tap for more details or any action
                    },
                  ),
                );
              },
            ),
    );
  }
}
