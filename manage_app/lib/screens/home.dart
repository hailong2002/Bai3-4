import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_app/screens/add_task.dart';
import 'package:manage_app/screens/login_screen.dart';
import 'package:manage_app/screens/task_details.dart';
import 'package:manage_app/services/authentication.dart';
import 'package:manage_app/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/task.dart';
import '../notification/notification.dart';
import '../view_models/task_view_model.dart';

class HomeScreent extends StatefulWidget {
  const HomeScreent({Key? key}) : super(key: key);

  @override
  State<HomeScreent> createState() => _HomeScreentState();
}

class _HomeScreentState extends State<HomeScreent> {
  bool loading = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  void _scheduleNotifications(List<Task> tasks) {
      final now = tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
      for (Task task in tasks) {
        final scheduledTime = tz.TZDateTime.from(task.time, tz.getLocation('Asia/Ho_Chi_Minh'));
        if (scheduledTime.isBefore(now)) {
          print('Scheduled time must be in the future');
        } else {
          Noti().scheduleNotification(
            title: 'Notification',
            body: 'You have a task need to do',
            scheduledNotificationDateTime: task.time,
          );
        }

    }
  }
  void logOut() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Logout', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure want to logout?'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          await AuthService().logoutUser();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreent()));
                        },
                        child: Text('Yes')
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: (){Navigator.pop(context);},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: Text('Cancel')
                    ),
                  ],
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddTaskScreent(id: '',)));
          }, 
          icon: const Icon(Icons.add),),
        title: const Text('Task List'),
        actions: [

          IconButton(onPressed: logOut, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(
        child: Center(
          child: StreamBuilder(
                stream: TaskViewModel().getAllTasksStream(),
                builder: (context, snapshot) {
                        if(snapshot.hasError){
                          return Text(snapshot.error.toString());
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const CircularProgressIndicator();
                        }
                        if(!snapshot.hasData){
                          return const Text("You don't have any task");
                        }
                        else{
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        List<Task> tasks = documents.map((doc) {
                          return Task(
                            id: doc['tid'],
                            name: doc['name'],
                            description: doc['description'],
                            time: (doc['time'] as Timestamp).toDate(), // Assuming 'time' is stored as a Timestamp
                          );
                        }).toList();
                        tasks.sort((a,b)=>a.time.compareTo(b.time));
                        _scheduleNotifications(tasks);
                        return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index){
                              Task task = tasks[index];
                              return ListTile(
                                leading: Text('${index+1}.', style: const TextStyle(fontSize: 20)),
                                title: Text('${task.name} - ${task.time.day}/${task.time.month}/${task.time.year} - ${task.time.hour}:${task.time.minute}'),
                                subtitle: Text(task.description,  overflow: TextOverflow.ellipsis,maxLines: 1,),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetails(id: task.id)));
                                },
                              );
                            }
                        );
                      }
                    },

                )

          //
          // loading ? const Center(child: CircularProgressIndicator()) :
          // Consumer<TaskViewModel>(
          //     builder: (context, taskViewModel, child) {
          //       List<Task> tasks = taskViewModel.tasks;
          //       return tasks.isEmpty ? const Text("You don't have any task") :
          //         ListView.builder(
          //         itemCount: tasks.length,
          //         itemBuilder: (context, index){
          //           Task task = tasks[index];
          //           return ListTile(
          //             leading: Text('${index+1}.', style: const TextStyle(fontSize: 20)),
          //             title: Text('${task.name} - ${task.time.day}/${task.time.month}/${task.time.year} - ${task.time.hour}:${task.time.minute}'),
          //             subtitle: Text(task.description,  overflow: TextOverflow.ellipsis,maxLines: 1,),
          //             onTap: (){
          //               Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetails(id: task.id)));
          //             },
          //           );
          //         }
          //     );
          //     }
          // )


        ),
      ),
    );
  }
}

