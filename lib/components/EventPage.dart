import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/events.dart';
import '../model/users.dart';
import 'EventDetails.dart';

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final List<UserModel> myFriends = [
    UserModel(
        id: "1",
        username: "HamadaBelGanzabeel",
        email: "hamadaginger@gmail.com"),
    UserModel(id: "2", username: "Mehalabeya", email: "Mehalabeya@Mehalabeya.com"),
    UserModel(id: "3", username: "Julie", email: "julie@shobrawy.com",profilePic: 'assets/sample.jpg'),
    UserModel(
      id: "4",
      username: "HappyTheAir",
      email: "sa3eed@elhawa.com",
      eventIds: ['3', '5,', '6'],
      profilePic: "assets/default_avatar.png",
    ),
    UserModel(id: "5", username: "Watermel0n", email: "watermelon@bateekh.com"),
    UserModel(
        id: "6",
        username: "EidSaeedRamadan",
        email: "eidsaeed@ramadankareem.com"),
    UserModel(id: "7", username: "AlragolAl3onab", email: "3enaby@3enabak.com"),
    UserModel(
        id: "8",
        username: "HamadaBelGanzabeel",
        email: "hamada@ginger.com",
        eventIds: ['1']),
    UserModel(id: "9", username: "ItsMeBolbol", email: "bolbol@sesew.com"),
    UserModel(
      id: "10",
      username: "Nognog",
      email: "nognog@nogg.com",
      profilePic: "assets/sample.jpg",
    ),
  ];

  final List<Event> upcomingEvents = [
    Event(
      id: "1",
      eventName: "Wedding",
      ownerId: "8", // ID of "HamadaBelGanzabeel"
      dateTime: DateTime(2024, 12, 5, 10, 0),
      category: EventCategory.wedding,
      giftIds: [],
    ),
    Event(
      id: "2",
      eventName: "Birthday",
      ownerId: "10", // ID of "Nognog"
      dateTime: DateTime(2025, 07, 23, 18, 30),
      category: EventCategory.birthday,
      giftIds: [],
    ),
    Event(
      id: "3",
      eventName: "Graduation",
      ownerId: "4", // ID of "HappyTheAir"
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "4",
      eventName: "Eid",
      ownerId: "6", // ID of "EidSaeedRamadan"
      dateTime: DateTime(2024, 11, 25, 18, 30),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "5",
      eventName: "Wedding",
      ownerId: "4", // ID of "HappyTheAir"
      dateTime: DateTime(2024, 12, 5, 10, 0),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "6",
      eventName: "Birthday",
      ownerId: "4", // ID of "HappyTheAir"
      dateTime: DateTime(2024, 12, 19, 10, 0),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "7",
      eventName: "3enaba",
      ownerId: "7", // ID of "HappyTheAir"
      dateTime: DateTime(2028, 10, 30, 20, 10),
      category: EventCategory.other,
      giftIds: ['1'],
    ),
    Event(
      id: "8",
      eventName: "Mehalabeya",
      ownerId: "2", // ID of "HappyTheAir"
      dateTime: DateTime(2090, 1, 1, 23, 50),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "9",
      eventName: "Engagement",
      ownerId: "3", // ID of "HappyTheAir"
      dateTime: DateTime(2290, 1, 1, 23, 50),
      category: EventCategory.other,
      giftIds: [],
    ),
    Event(
      id: "10",
      eventName: "Wedding",
      ownerId: "3",
      dateTime: DateTime(2021, 1, 1, 23, 50),
      category: EventCategory.wedding,
      giftIds: [],
    ),
  ];

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
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            // Get user by ID
            UserModel? user =
            UserModel.getUserById(upcomingEvents[index].ownerId, myFriends);

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
                    border: Border.all(color: theme.colorScheme.primary, width: 3),
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.tertiary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          user?.profilePic ?? "assets/default_avatar.png",
                        ),
                      ),
                      title: Text(
                        '${user?.username ?? 'Unknown'}\'s ${upcomingEvents[index].eventName}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy HH:mm')
                              .format(upcomingEvents[index].dateTime),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetails(
                              event: upcomingEvents[index],
                            ),
                          ),
                        );
                      },
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

