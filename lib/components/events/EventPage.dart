import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/events/EventsViewModel.dart';
import 'package:intl/intl.dart';
import '../../model/events.dart';
import '../eventdetails/EventDetails.dart';

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
}
class _EventsState extends State<Events> {
  final _viewModel = EventsViewModel();

  String filterStatus = 'Upcoming';
  bool isSortedAscending = true;
  late Future<List<Event>> eventsFuture;

  @override
  void initState() {
    super.initState();
    fetchFilteredEvents();
  }

  void fetchFilteredEvents() {
    setState(() {
      eventsFuture = _viewModel.getFilteredEvents(filterStatus, isSortedAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hedieaty', style: GoogleFonts.cairo(fontSize: 30)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown for filtering
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface,
                  ),
                  child: DropdownButton<String>(
                    value: filterStatus,
                    items: ['Upcoming', 'Passed', 'All']
                        .map(
                          (status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      filterStatus = value!;
                      fetchFilteredEvents();
                    },
                    underline: SizedBox(), // Removes the default underline
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                // Sort button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSortedAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      isSortedAscending = !isSortedAscending;
                      fetchFilteredEvents();
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading data"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No events available"));
                  }

                  final events = snapshot.data!;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                        child: Card(
                          color: theme.colorScheme.surface,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.colorScheme.primary, width: 3),
                              borderRadius: BorderRadius.circular(20),
                              color: theme.colorScheme.tertiary,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: _viewModel.getEventDetails(event),
                                builder: (context, detailsSnapshot) {
                                  if (detailsSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      title: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (detailsSnapshot.hasError) {
                                    return ListTile(
                                      title: Text("Error loading user details"),
                                    );
                                  } else if (detailsSnapshot.hasData) {
                                    final details = detailsSnapshot.data!;
                                    final username =
                                        details['ownerDetails']['username'] ?? 'Unknown';
                                    final profilePic =
                                        details['ownerDetails']['profilePic'] ??
                                            'assets/default_avatar.png';

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        radius: 40,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(profilePic),
                                        ),
                                      ),
                                      title: Text(
                                        '$username\'s ${event.eventName}',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                      subtitle: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          DateFormat('dd-MM-yyyy HH:mm')
                                              .format(event.dateTime),
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetails(event: event),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text("No details available"),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
