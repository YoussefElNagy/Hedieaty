import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/events.dart';
import '../data/users.dart';
import 'GiftManagement.dart';

class MyEvents extends StatefulWidget {
  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final User currentUser = User(
    id: "4",
    username: "HappyTheAir",
    email: "sa3eed@elhawa.com",
    eventIds: ['3'],
    profilePic: "assets/default_avatar.png",
  );

  List<Event> allEvents = [
    Event(
      id: "3",
      eventName: "Graduation",
      ownerId: "4",
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: ['1','3'],
    ),
    Event(
      id: "6",
      eventName: "Wedding",
      ownerId: "4",
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: [],
    ),
    Event(
      id: "9",
      eventName: "Birthday",
      ownerId: "4",
      dateTime: DateTime(2025, 12, 5, 10, 0),
      category: EventCategory.other,
      status: EventStatus.active,
      giftIds: ['1','2'],
    ),
  ];

  List<Event> get currentUserEvents {
    return allEvents.where((event) => event.ownerId == currentUser.id).toList();
  }

  void _createOrEditEvent({Event? event}) {
    final isEditing = event != null;
    final TextEditingController nameController =
    TextEditingController(text: event?.eventName ?? '');
    final TextEditingController dateController = TextEditingController(
      text: event != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(event.dateTime)
          : '',
    );

    EventCategory selectedCategory = event?.category ?? EventCategory.other;
    EventStatus selectedStatus = event?.status ?? EventStatus.active;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? "Edit Event" : "Create Event",
                    style: GoogleFonts.cairo(
                      textStyle: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Event Name",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: "Date & Time (yyyy-MM-dd HH:mm)",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final fullDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          setState(() {
                            dateController.text =
                                DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<EventCategory>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: EventCategory.values.map((EventCategory category) {
                      return DropdownMenuItem<EventCategory>(
                        value: category,
                        child: Text(
                          category.toString().split('.').last,
                          style: GoogleFonts.cairo(),
                        ),
                      );
                    }).toList(),
                    onChanged: (EventCategory? value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<EventStatus>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: "Status",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: EventStatus.values.map((EventStatus status) {
                      return DropdownMenuItem<EventStatus>(
                        value: status,
                        child: Text(
                          status.toString().split('.').last,
                          style: GoogleFonts.cairo(),
                        ),
                      );
                    }).toList(),
                    onChanged: (EventStatus? value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              dateController.text.isNotEmpty) {
                            setState(() {
                              final eventDate = DateFormat('yyyy-MM-dd HH:mm')
                                  .parse(dateController.text);
                              if (isEditing) {
                                event!.eventName = nameController.text;
                                event.dateTime = eventDate;
                                event.category = selectedCategory;
                                event.status = selectedStatus;
                              } else {
                                allEvents.add(Event(
                                  id: DateTime.now().toString(),
                                  eventName: nameController.text,
                                  ownerId: currentUser.id,
                                  dateTime: eventDate,
                                  category: selectedCategory,
                                  status: selectedStatus,
                                  giftIds: [],
                                ));
                              }
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(isEditing ? "Save" : "Create"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteEvent(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Event", style: GoogleFonts.cairo()),
        content: Text(
          "Are you sure you want to delete this event?",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                allEvents.removeWhere((event) => event.id == eventId);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),

          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hedeyeti',
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                          width: 3
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 0),
                      child: Text(event.eventName, style: theme.textTheme.headlineMedium),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime)}',
                          style: GoogleFonts.cairo(),
                        ),
                        Text(
                          'Category: ${event.category.name}',
                          style: GoogleFonts.cairo(),
                        ),
                        Text(
                          'Status: ${event.status.name}',
                          style: GoogleFonts.cairo(),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _createOrEditEvent(event: event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,color: Colors.red,),
                          onPressed: () => _deleteEvent(event.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftManagement(event: event),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => _createOrEditEvent(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
