import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manage_app/screens/add_task.dart';
import 'package:manage_app/services/database_service.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../view_models/task_view_model.dart';
import 'home.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  void showDeleteDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Confirm delete', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure want to delete'),
                ElevatedButton(
                    onPressed: (){
                      TaskViewModel().deleteTask(widget.id);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreent()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Delete')
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(),
        title: const Text('Task details '),
        actions: [
          IconButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTaskScreent(id: widget.id)));
              },
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              onPressed:(){
                showDeleteDialog();
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
            stream: TaskViewModel().getTasksStream(widget.id),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if(!snapshot.hasData){
                return const Text('This task is empty');
              }
              else{
                DocumentSnapshot doc = snapshot.data!.docs[0];
                Task task = Task(id: doc['tid'], name: doc['name'], description: doc['description'], time: doc['time'].toDate());
                return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: Text('${task.time.day}/${task.time.month}/${task.time.year} - ${task.time.hour}:${task.time.minute}')
                        ),
                        const SizedBox(height: 15),
                        Text(task.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(task.description,  style: const TextStyle(fontSize: 18)),
                      ],
                    );
              }
            },

          )

        ),
      ),
    );
  }
}
