import 'package:flutter/material.dart';
import 'package:todo_app/modals/task_modal.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskModal taskModal =
        ModalRoute.of(context)!.settings.arguments as TaskModal;

    return Scaffold(
      appBar: AppBar(
        title: Text(taskModal.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              taskModal.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              taskModal.description,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
