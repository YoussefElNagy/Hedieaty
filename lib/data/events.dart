import 'package:flutter/material.dart';
import 'users.dart';

class Event{
  String eventName;
  String owner;
  DateTime dateTime;
  String category;
  String status;

  Event({
    required this.eventName,
    required this.owner,
    required this.dateTime,
    required this.category,
    required this.status
  });
}

