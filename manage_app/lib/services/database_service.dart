import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class DatabaseService{
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');
  Future addTask(Task task) async{
    try{
      DocumentReference documentReference = taskCollection.doc();
      await documentReference.set({
        'tid': documentReference.id,
        'name': task.name,
        'description': task.description,
        'time': Timestamp.fromDate(task.time)
      });
    }catch(e){
      print(e);
    }
  }

  Future editTask(String id, Task task) async{
    try{
      await taskCollection.doc(id).update({
        'name': task.name,
        'description': task.description,
        'time': Timestamp.fromDate(task.time)
      });
    }catch(e){
      print(e);
    }
  }

  Future deleteTask(String id) async{
    try{
     await taskCollection.doc(id).delete();
    }catch(e){
      print(e);
    }
  }


}