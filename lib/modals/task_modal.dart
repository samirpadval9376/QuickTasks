import 'package:flutter/material.dart';

class TaskModal {
  String title;
  String description;
  DateTime time = DateTime.now();
  DateTime date = DateTime.now();

  TaskModal(
    this.title,
    this.description,
    this.time,
    this.date,
  );

  factory TaskModal.fromModal({required Map data}) {
    return TaskModal(
      data['title'],
      data['description'],
      DateTime.fromMillisecondsSinceEpoch(data['time']),
      DateTime.fromMillisecondsSinceEpoch(data['date']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'title': title,
      'description': description,
      'time': time.millisecondsSinceEpoch,
      'date': date.millisecondsSinceEpoch,
    };
  }
}
