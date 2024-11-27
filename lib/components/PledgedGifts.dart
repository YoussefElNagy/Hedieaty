import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/gifts.dart';

class PledgedGiftsPage extends StatefulWidget {
  final String currentUserId; // Pass current user's ID

  PledgedGiftsPage({required this.currentUserId});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}
class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  final List<Gift> giftList = [
    Gift(
      id: '1',
      giftName: 'Smartphone',
      description: 'Latest model with high-end features.',
      price: 500.0,
      ownerId: 'user123',
      pledgedById: 'user456', // This gift is pledged by user456
      status: GiftStatus.available,
      isPledged: true,
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
      pledgedById: 'user789', // This gift is pledged by user789
      status: GiftStatus.pledged,
      isPledged: true,
      category: GiftCategory.clothing,
      eventId: 'event2',
    ),
    // Add more sample gifts with pledge data here...
  ];

  @override
  Widget build(BuildContext context) {
    final List<Gift> giftList = [
      Gift(
        id: '1',
        giftName: 'Smartphone',
        description: 'Latest model with high-end features.',
        price: 500.0,
        ownerId: 'user123',
        pledgedById: widget.currentUserId, // This gift is pledged by user456
        status: GiftStatus.available,
        isPledged: true,
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
        pledgedById: widget.currentUserId,
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.clothing,
        eventId: 'event2',
      ),
      Gift(
        id: '3',
        giftName: 'Bluetooth Headphones',
        description: 'Noise-cancelling over-ear headphones with excellent sound quality.',
        price: 120.0,
        image: null, // No image, will use default
        ownerId: 'user123',
        pledgedById: widget.currentUserId, // This gift is pledged by the current user
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.electronics,
        eventId: 'event3',
      ),

      Gift(
        id: '4',
        giftName: 'Luxury Watch',
        description: 'Elegant wristwatch with a stainless steel band.',
        price: 250.0,
        image: null, // No image, will use default
        ownerId: 'user789',
        pledgedById: widget.currentUserId, // This gift is pledged by the current user
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.clothing,
        eventId: 'event4',
      ),

      Gift(
        id: '5',
        giftName: 'Gaming Laptop',
        description: 'High-performance gaming laptop with a powerful GPU.',
        price: 1200.0,
        image: null, // No image, will use default
        ownerId: 'user456',
        pledgedById: widget.currentUserId, // This gift is pledged by the current user
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.electronics,
        eventId: 'event5',
      ),

      Gift(
        id: '6',
        giftName: 'Designer Handbag',
        description: 'Luxurious leather handbag with a timeless design.',
        price: 350.0,
        image: null, // No image, will use default
        ownerId: 'user234',
        pledgedById: widget.currentUserId, // This gift is pledged by the current user
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.clothing,
        eventId: 'event6',
      ),

      Gift(
        id: '7',
        giftName: 'Smartwatch',
        description: 'Advanced smartwatch with health and fitness tracking features.',
        price: 180.0,
        image: null, // No image, will use default
        ownerId: 'user567',
        pledgedById: widget.currentUserId, // This gift is pledged by the current user
        status: GiftStatus.pledged,
        isPledged: true,
        category: GiftCategory.electronics,
        eventId: 'event7',
      ),

      // Add more sample gifts with pledge data here...
    ];
    // Filter the list of gifts to show only those pledged by the current user
    final pledgedGifts = giftList
        .where((gift) => gift.pledgedById == widget.currentUserId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pledged Gifts',
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: pledgedGifts.isEmpty
          ? Center(
        child: Text(
          'You have not pledged any gifts yet!',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF292f36),
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25, // Size of the avatar
                  backgroundImage: gift.image != null
                      ? NetworkImage(gift.image!) // If image exists, use it
                      : AssetImage('assets/default_gift.png')
                  as ImageProvider, // Default image if no image
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gift.giftName,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF292f36),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      gift.ownerId,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF292f36),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  "Category: ${gift.category.toString().split('.').last} \nPrice: \$${gift.price}",
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF292f36),
                    fontSize: 14,
                  ),
                ),

                onTap: () {
                  // Handle on tap for more details or any action
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
