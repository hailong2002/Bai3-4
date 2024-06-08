import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/task.dart';
import '../services/database_service.dart';

class TaskViewModel{


  Stream<QuerySnapshot<Object?>> getAllTasksStream() {
    return DatabaseService().taskCollection.snapshots();
  }

  Stream<QuerySnapshot<Object?>> getTasksStream(String id) {
    return DatabaseService().taskCollection.where('tid', isEqualTo: id).snapshots();
  }

  // Future<void> getAllTasks() async{
  //   QuerySnapshot snapshot = await DatabaseService().taskCollection.get();
  //   List<Task> tasks = await Future.wait(snapshot.docs.map((e) => getTask(e.id)).toList());
  //   tasks.sort((a,b) => a.time.compareTo(b.time));
  //   _tasksController.add(tasks);
  // }


  Future<Task> getTask(String id) async{
    DocumentSnapshot snapshot = await DatabaseService().taskCollection.doc(id).get();
    return Task(
        id: id,
        name: snapshot.get('name'),
        description: snapshot.get('description'),
        time: snapshot.get('time').toDate()
    );
  }

  Future<void> addTask(Task task) async{
    await DatabaseService().addTask(task);

  }

  Future<void> editTask(String id, Task task) async{
    await DatabaseService().editTask(id, task);
  }

  Future<void> deleteTask(String id) async{
    await DatabaseService().deleteTask(id);
  }



}