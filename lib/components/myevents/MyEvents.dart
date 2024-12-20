import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedeyeti/components/myevents/MyEventsVM.dart';
import 'package:hedeyeti/model/users.dart';
import 'package:intl/intl.dart';
import '../../model/events.dart';
import '../mygifts/GiftManagement.dart';

class MyEvents extends StatefulWidget {
  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  void _deleteEvent(String eventId, String userId) {
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
            onPressed: () async {
              await MyEventsViewModel().deleteCurrentEvent(eventId, userId);
              Navigator.pop(context);
              refreshData();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    futureData = MyEventsViewModel().initialiseData();
    print('init ${futureData}');
    super.initState();
  }

  void refreshData() {
    setState(() {
      futureData = MyEventsViewModel().initialiseData();
    });
  }

  Future<void> _createOrEditEvent({Event? event, UserModel? user}) async {
    final isEditing = event != null;
    final TextEditingController nameController =
        TextEditingController(text: event?.eventName ?? '');
    final TextEditingController locationController =
        TextEditingController(text: event?.location ?? '');
    final TextEditingController dateController = TextEditingController(
      text: event != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(event.dateTime)
          : '',
    );
    EventCategory selectedCategory = event?.category ?? EventCategory.other;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          key: const Key('eventDialog'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        textStyle: Theme.of(context).textTheme.headlineSmall),
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
                          if (pickedDate.isBefore(DateTime.now())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please select a valid date")),
                            );
                          }
                          setState(() {
                            dateController.text = DateFormat('yyyy-MM-dd HH:mm')
                                .format(fullDateTime);
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: "Event Location",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<EventCategory>(
                    key: const Key('eventDropDown'),
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
                        onPressed: () async {
                          if (nameController.text.isNotEmpty &&
                              dateController.text.isNotEmpty) {
                            final eventDate = DateFormat('yyyy-MM-dd HH:mm')
                                .parse(dateController.text);

                            // Check if event date is in the past
                            if (eventDate.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "The event date cannot be in the past."),
                                ),
                              );
                              return; // Prevent event creation
                            }

                            if (isEditing) {
                              // Update event using ViewModel
                              await MyEventsViewModel().updateEvent(
                                Event(
                                  id: event.id,
                                  eventName: nameController.text,
                                  ownerId: user!.id,
                                  dateTime: eventDate,
                                  category: selectedCategory,
                                  location: locationController.text,
                                  giftIds: event.giftIds,
                                ),
                              );
                            } else {
                              // Create event using ViewModel
                              await MyEventsViewModel().createEvent(
                                Event(
                                  id: MyEventsViewModel().generateEventId(),
                                  eventName: nameController.text,
                                  ownerId: user!.id,
                                  dateTime: eventDate,
                                  category: selectedCategory,
                                  location: locationController.text,
                                  giftIds: [],
                                ),
                              );
                            }

                            Navigator.pop(context);
                            setState(() {
                              futureData = MyEventsViewModel()
                                  .initialiseData(); // Refresh data after add/update
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Please fill all required fields.')),
                            );
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
      body: FutureBuilder<Map<String, dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading data"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No events available"));
            }
            final user = snapshot.data!['user'];
            final events = snapshot.data!['events'];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  Event event = events[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 0),
                            child: Text(event.eventName,
                                style: theme.textTheme.headlineMedium),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${DateFormat('dd-MM-yyyy HH:mm').format(event.dateTime)}',
                                    style: GoogleFonts.cairo(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      color: theme.colorScheme.primary,
                                    ),
                                    Text(
                                      '${event.location ?? "Not defined..."}',
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Category: ${event.category.name}',
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _createOrEditEvent(
                                    event: event, user: user),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteEvent(event.id, user.id);
                                  refreshData();
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GiftManagement(event: event),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          final user = (await futureData)['user'];
          if (user != null) {
            _createOrEditEvent(user: user);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User data is not available')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
