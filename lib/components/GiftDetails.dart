import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/gifts.dart'; // Assuming Gift model/data resides here

class GiftDetails extends StatelessWidget {
  final Gift gift;

  GiftDetails({required this.gift});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gift Details',
          style: GoogleFonts.cairo(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gift Image Section with Primary Color Border
            Center(
              child: Container(
                height: 300, // Increased height to prevent overflow
                decoration: BoxDecoration(
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        gift.image ?? 'assets/default_gift.png',
                        width: double
                            .infinity, // Stretch the image to fill the container width
                        height: double
                            .infinity, // Stretch the image to fill the container height
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/default_gift.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Text(
                            gift.giftName,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gift Details Section with Secondary Background Color
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Category:', gift.category.name),
                    _buildDetailRow(
                        'Price:', '\$${gift.price.toStringAsFixed(2)}'),
                    SizedBox(height: 10),
                    Text(
                      'Status: ${gift.isPledged ? "Pledged" : "Available"}',
                      style: TextStyle(
                          color: gift.isPledged ? Colors.orange : Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            // Duplicate Card Container (Your Request to Place Description Here)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        gift.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Handle overflow in text
                        maxLines:
                            4, // Limit the number of lines for better overflow control
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Owner Information Section with Avatar
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              gift.ownerId ?? 'assets/default_avatar.png'),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Requested by: ${gift.ownerId}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        // Handle owner's profile navigation here
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Pledge Information Section with Secondary Background Color
            if (gift.isPledged) ...[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pledged By: ${gift.pledgedById}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Action Button: Pledge or Unpledge
            if (!gift.isPledged)
              ElevatedButton.icon(
                onPressed: () {
                  // Add logic for pledging the gift
                },
                icon: Icon(Icons.favorite_border),
                label: Text('Pledge This Gift'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            if (gift.isPledged)
              ElevatedButton.icon(
                onPressed: () {
                  // Add logic for unpledging or updating the pledge
                },
                icon: Icon(Icons.favorite),
                label: Text('Unpledge This Gift'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
