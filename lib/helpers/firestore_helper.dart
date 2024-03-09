import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/modals/user_modal.dart';

import 'auth_helper.dart';

enum AdTypes {
  bannerAd,
  interstitialAd,
  appOpenAd,
  rewardAd,
  nativeAd,
}

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String collectionPath = "Users";
  String collection = "Tasks";

  Future<String> getAddId({required AdTypes adTypes}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection('AdUnitId').doc(adTypes.name).get();
    Map<String, dynamic>? adData = data.data() as Map<String, dynamic>;
    String adId = adData['id'];

    return adId;
  }

  Future<void> addUser(
      {required UserModal userModal, required String uid}) async {
    await fireStore.collection(collectionPath).doc(uid).set(userModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return fireStore
        .collection(collectionPath)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  addTask({required TaskModal taskModal}) async {
    User? user = Auth.auth.firebaseAuth.currentUser;

    await fireStore
        .collection(collection)
        .doc(user!.uid)
        .collection('My Tasks')
        .doc(taskModal.time.millisecondsSinceEpoch.toString())
        .set(taskModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUid() {
    User? user = Auth.auth.firebaseAuth.currentUser;
    return fireStore
        .collection(collection)
        .doc(user!.uid)
        .collection('My Tasks')
        .snapshots();
  }

  Future<void> deleteTask({required String time}) async {
    User? user = Auth.auth.firebaseAuth.currentUser;
    await fireStore
        .collection(collection)
        .doc(user!.uid)
        .collection('My Tasks')
        .doc(time)
        .delete();
  }
}
