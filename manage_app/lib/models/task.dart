import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_app/services/database_service.dart';

class Task{

  String id;
  String name;
  String description;
  DateTime time;

  Task({required this.id, required this.name, required this.description, required this.time});



}