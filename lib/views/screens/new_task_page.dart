import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controllers/firestore_controller.dart';
import 'package:todo_app/helpers/firestore_helper.dart';
import 'package:todo_app/helpers/notification_helper.dart';
import 'package:todo_app/modals/task_modal.dart';

class NewTaskPage extends StatelessWidget {
  NewTaskPage({super.key});

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Provider.of<FireStoreController>(context, listen: false).now();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: "Enter Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: "Enter Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<FireStoreController>(builder: (context, provider, _) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.selectDate(context: context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        SizedBox(
                          width: s.width * 0.02,
                        ),
                        const Text("Select Date"),
                        SizedBox(
                          width: s.width * 0.4,
                        ),
                        Text(
                            "${provider.date.day.toString().padLeft(2, '0')}/${provider.date.month.toString().padLeft(2, '0')}/${provider.date.year}"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.selectTime(context: context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.watch_later),
                        SizedBox(
                          width: s.width * 0.02,
                        ),
                        const Text("Select Time"),
                        SizedBox(
                          width: s.width * 0.44,
                        ),
                        Text(
                            "${provider.time.hour.toString().padLeft(2, '0')}:${provider.time.minute.toString().padLeft(2, '0')} ${provider.time.hour >= 12 ? 'PM' : 'AM'}"),
                      ],
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: s.height * 0.065,
              width: s.width,
              child: Consumer<FireStoreController>(
                  builder: (context, provider, _) {
                return ElevatedButton(
                  onPressed: () async {
                    TaskModal taskModal = TaskModal(
                      title.text,
                      description.text,
                      provider.dateTime,
                      provider.dateTime,
                    );

                    await FireStoreHelper.fireStoreHelper
                        .addTask(taskModal: taskModal);

                    await NotificationHelper.notificationHelper
                        .scheduleNotification(
                      dateTime: provider.dateTime,
                      title: title.text,
                    );

                    log("${provider.dateTime.hour}");
                  },
                  child: Text(
                    "Add Task",
                    style: GoogleFonts.roboto(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
