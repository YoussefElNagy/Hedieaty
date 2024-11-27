import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/events.dart';
import '../data/users.dart';
import 'EventDetails.dart';

class MyEvents extends StatefulWidget {
  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final User currentUser = User(
    id: "4",
    username: "HappyTheAir",
    email: "sa3eed@elhawa.com",
    eventIds: ['3', '5', '6'],
    profilePic: "assets/default_avatar.png",
  );

  final List<Event> allEvents = [
    Event(
      id: "1",
      eventName: "Wedding",
      ownerId: "8", // HamadaBelGanzabeel's event
      dateTime: DateTime(2024, 12, 5, 10, 0),
      category: EventCategory.wedding,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "2",
      eventName: "Birthday",
      ownerId: "10", // Nognog's event
      dateTime: DateTime(2025, 07, 23, 18, 30),
      category: EventCategory.birthday,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "3",
      eventName: "Graduation",
      ownerId: "4", // Current user's event
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "4",
      eventName: "Eid",
      ownerId: "6", // EidSaeedRamadan's event
      dateTime: DateTime(2024, 11, 25, 18, 30),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "5",
      eventName: "Wedding",
      ownerId: "4", // Current user's event
      dateTime: DateTime(2024, 12, 5, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "6",
      eventName: "Birthday",
      ownerId: "4", // Current user's event
      dateTime: DateTime(2024, 12, 19, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "7",
      eventName: "3enaba",
      ownerId: "7", // AlragolAl3onab's event
      dateTime: DateTime(2028, 10, 30, 20, 10),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: ['1'],
    ),
    Event(
      id: "8",
      eventName: "Mehalabeya",
      ownerId: "2", // Mehalabeya's event
      dateTime: DateTime(2090, 1, 1, 23, 50),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
  ];

  List<Event> get currentUserEvents {
    return allEvents.where((event) => event.ownerId == currentUser.id).toList();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: ListView.builder(
          itemCount: currentUserEvents.length,
          itemBuilder: (context, index) {
            Event event = currentUserEvents[index];

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
                    border: Border.all(color: theme.colorScheme.tertiary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,20,10,30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'My ${event.eventName}',
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Date & Time: ${DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Category: ${event.category.name}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Status: ${event.status.name}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
