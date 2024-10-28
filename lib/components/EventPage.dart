import 'package:flutter/material.dart';
import '../data/events.dart';
import 'package:intl/intl.dart';

class Events extends StatelessWidget {
  final List<Event> upcomingEvents=[
    Event(
      eventName: "Wedding",
      owner: "HamadaBelGanzabeel",
      dateTime: DateTime(2024, 12, 5, 10, 0),
      category: "Wedding",
      status: "Upcoming",
    ),
    Event(
      eventName: "Birthday",
      owner: "Nognog",
      dateTime: DateTime(2024, 11, 25, 18, 30),
      category: "Entertainment",
      status: "Upcoming",
    ),
    Event(
      eventName: "Graduation",
      owner: "HappyTheAir",
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: "Graduation",
      status: "Upcoming",
    ),
    Event(
      eventName: "Eid",
      owner: "EidSaeedRamadan",
      dateTime: DateTime(2024, 11, 25, 18, 30),
      category: "Eid",
      status: "Upcoming",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return          Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
      child: Expanded(
        child: ListView.builder(
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
              child: Card(
                color: Color(0xFFFAFAFA),
                elevation: 2,
                child: Container(
                  color: Color(0xFFBEEFEB),
                  child: ListTile(
                    title: Text(
                      '${upcomingEvents[index].owner}\'s ${upcomingEvents[index].eventName}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    // leading: CircleAvatar(
                    //   backgroundImage: AssetImage('assets/default_avatar.png'),
                    //   // onBackgroundImageError: (_, __) => AssetImage('assets/default_avatar.png'),
                    // ),
                    subtitle:  Text(DateFormat('dd-MM-yyyy HH:mm').format(upcomingEvents[index].dateTime), style: theme.textTheme.bodySmall),
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