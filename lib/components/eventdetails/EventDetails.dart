import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/eventdetails/EventDetailsVM.dart';
import 'package:intl/intl.dart';
import '../../model/events.dart';
import '../../model/gifts.dart';
import '../giftdetails/GiftDetails.dart'; // Assuming this is where the Gift model/data resides

class EventDetails extends StatefulWidget {
  final Event event;

  EventDetails({required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = EventDetailsViewModel().initialiseEventData(widget.event);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading event data"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("No event available"));
                  }
                  final user = snapshot.data!['owner'];

                  return Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      border: Border.all(
                          color: theme.colorScheme.primary, width: 4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.username}'s ${widget.event.eventName}",
                                  style: theme.textTheme.headlineSmall,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(widget.event.dateTime)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Location: ${widget.event.location}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Category: ${widget.event.category.name}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            SizedBox(height: 20),

            // Gift List Section
            Text(
              'Gifts for this Event:',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 10),
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
                  final gifts = snapshot.data!['gifts'];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: gifts.length,
                      itemBuilder: (context, index) {
                        Gift gift = gifts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: gift.isPledged
                                    ? Colors.orange[200]!
                                    : theme.colorScheme.primary,
                                width: 3,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  gift.image ?? 'assets/default_gift.png',
                                ),
                              ),
                              title: Text(
                                gift.giftName,
                                style: theme.textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: ${gift.category.name}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    'Price: \$${gift.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    'Description: ${gift.description}',
                                    style: theme.textTheme.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Status: ${gift.isPledged ? "Pledged" : "Available"}',
                                    style: TextStyle(
                                      color: gift.isPledged
                                          ? Colors.orange
                                          : theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                gift.isPledged
                                    ? Icons.check_circle
                                    : Icons.pending_actions,
                                color: gift.isPledged
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GiftDetails(gift: gift),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
