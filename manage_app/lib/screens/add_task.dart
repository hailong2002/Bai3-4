import 'package:flutter/material.dart';
import 'package:manage_app/screens/task_details.dart';
import 'package:manage_app/services/database_service.dart';
import 'package:manage_app/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../view_models/task_view_model.dart';
import 'home.dart';

class AddTaskScreent extends StatefulWidget {
  const AddTaskScreent({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<AddTaskScreent> createState() => _AddTaskScreentState();
}

class _AddTaskScreentState extends State<AddTaskScreent> {
  final key = GlobalKey<FormState>();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();


  @override
  void initState() {
    super.initState();
    getTask(widget.id);
  }

  Future<void> getTask(id) async{
    if(widget.id.isNotEmpty){
      Task task = await TaskViewModel().getTask(widget.id);
      setState(() {
        textNameController.text = task.name;
        textDescriptionController.text = task.description;
        selectedDate = task.time;
        selectedTime = TimeOfDay(hour: task.time.hour, minute: task.time.minute);
      });
    }
  }

  Future<void> _selectDate() async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.id.isEmpty ? DateTime.now() : selectedDate,
        firstDate: DateTime(2000, 1,1 ),
        lastDate: DateTime(2099, 1, 1)
    );
    if(picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async{
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: widget.id.isEmpty ? TimeOfDay.now() : selectedTime ,
        initialEntryMode : TimePickerEntryMode.input
    );
    if(picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id.isEmpty ? const Text('Add new task') : const Text('Edit task'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    controller: textNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter name'
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter name of task';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: textDescriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Enter description'
                    ),
                    maxLines: 4,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ElevatedButton(onPressed: _selectDate, child: const Text('Select Date', style: TextStyle(fontSize: 20),)),
                      const SizedBox(width: 15),
                      Text('${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}',style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ElevatedButton(onPressed: _selectTime, child: const Text('Select Time', style: TextStyle(fontSize: 20),)),
                      const SizedBox(width: 15),
                      Text('${selectedTime.hour}:${selectedTime.minute}', style: const TextStyle(fontSize: 20),)
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25)
                        ),
                        onPressed: (){
                          if(key.currentState!.validate()){
                            DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute
                            );
                            Task task = Task(
                                id: '',
                                name: textNameController.text,
                                description: textDescriptionController.text,
                                time: selectedDateTime
                            );
                            if(widget.id.isEmpty){
                              TaskViewModel().addTask(task);
                              showSnackBar(context, 'Add new task success');
                            }else{
                              Navigator.pop(context, task);
                              TaskViewModel().editTask(widget.id, task);
                              showSnackBar(context, 'Edit task success');
                            }
                          }
                        },
                        child: widget.id.isEmpty ? const Text('Add', style: TextStyle(fontSize: 20)) : const Text('Edit', style: TextStyle(fontSize: 20))
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
