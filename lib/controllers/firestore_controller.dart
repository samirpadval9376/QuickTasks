import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/helpers/auth_helper.dart';

class FireStoreController extends ChangeNotifier {
  String uid = '';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  TimeOfDay? picked;

  FireStoreController() {
    getUid();
  }

  getUid() {
    User? user = Auth.auth.firebaseAuth.currentUser;
    uid = user!.uid;
    notifyListeners();
  }

  selectDate({required BuildContext context}) async {
    DateTime pickedDate = DateTime.now();
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (picked != null && picked != date) {
      date = picked;
      notifyListeners();
    }
  }

  selectTime({required BuildContext context}) async {
    TimeOfDay pickedTime = TimeOfDay.now();
    picked = await showTimePicker(context: context, initialTime: pickedTime);

    if (picked != null && picked != time) {
      time = picked as TimeOfDay;
      notifyListeners();
    }
    toDateTime();
  }

  now() {
    date = DateTime.now();
    time = TimeOfDay.now();
    notifyListeners();
  }

  toDateTime() {
    dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    notifyListeners();
  }
}
