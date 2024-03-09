import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controllers/firestore_controller.dart';
import 'package:todo_app/helpers/ads_helper.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/modals/user_modal.dart';

import '../../helpers/firestore_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TODO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white70,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: s.height,
              width: s.width,
              child: Consumer<FireStoreController>(
                  builder: (context, provider, _) {
                return StreamBuilder(
                  stream: FireStoreHelper.fireStoreHelper.getUid(),
                  builder: (context, snapshot) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                        snapshot.data?.docs ?? [];

                    List<TaskModal> allTasks = docs
                        .map((e) => TaskModal.fromModal(data: e.data()))
                        .toList();

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: allTasks.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('detail_page',
                                  arguments: allTasks[index]);
                            },
                            child: Consumer<FireStoreController>(
                                builder: (context, provider, _) {
                              DateTime dateTime = DateTime.now();
                              log("provider : ${allTasks[index].time.minute}");
                              log("normal : ${dateTime.minute}");

                              return allTasks[index].date.day < dateTime.day
                                  ? Card(
                                      color: Colors.red,
                                      child: ListTile(
                                        title: Text(
                                          allTasks[index].title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${allTasks[index].date.day.toString()}/${allTasks[index].date.month.toString().padLeft(2, '0')}/${allTasks[index].date.year.toString()} ${allTasks[index].time.hour.toString()}:${allTasks[index].time.minute.toString()} ${allTasks[index].time.minute >= 12 ? 'PM' : 'AM'}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .deleteTask(
                                                    time: allTasks[index]
                                                        .time
                                                        .millisecondsSinceEpoch
                                                        .toString());
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : allTasks[index].time.hour < dateTime.hour
                                      ? Card(
                                          color: Colors.red,
                                          child: ListTile(
                                            title: Text(allTasks[index].title),
                                            subtitle: Text(
                                                "${allTasks[index].date.day.toString().padLeft(2, '0')}/${allTasks[index].date.month.toString().padLeft(2, '0')}/${allTasks[index].date.year.toString()} ${allTasks[index].time.hour.toString()}:${allTasks[index].time.minute.toString()} ${allTasks[index].time.minute >= 12 ? 'PM' : 'AM'}"),
                                            trailing: IconButton(
                                              onPressed: () async {
                                                await FireStoreHelper
                                                    .fireStoreHelper
                                                    .deleteTask(
                                                        time: provider.dateTime
                                                            .toString())
                                                    .then((value) =>
                                                        log("Task Deleted..."));
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : allTasks[index].time.minute <=
                                              dateTime.minute
                                          ? Card(
                                              color: Colors.red,
                                              child: ListTile(
                                                title: Text(
                                                  allTasks[index].title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${allTasks[index].date.day.toString().padLeft(2, '0')}/${allTasks[index].date.month.toString().padLeft(2, '0')}/${allTasks[index].date.year.toString()} ${allTasks[index].time.hour.toString()}:${allTasks[index].time.minute.toString().padLeft(2, '0')} ${allTasks[index].time.minute >= 12 ? 'PM' : 'AM'}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  onPressed: () async {
                                                    await FireStoreHelper
                                                        .fireStoreHelper
                                                        .deleteTask(
                                                            time: provider
                                                                .dateTime
                                                                .toString())
                                                        .then((value) => log(
                                                            "Task Deleted..."));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Card(
                                              color: Colors.white70,
                                              child: ListTile(
                                                title: Text(
                                                  allTasks[index].title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${allTasks[index].date.day.toString().padLeft(2, '0')}/${allTasks[index].date.month.toString().padLeft(2, '0')}/${allTasks[index].date.year.toString()} ${allTasks[index].time.hour.toString()}:${allTasks[index].time.minute.toString().padLeft(2, '0')} ${allTasks[index].time.minute >= 12 ? 'PM' : 'AM'}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  onPressed: () async {
                                                    await FireStoreHelper
                                                        .fireStoreHelper
                                                        .deleteTask(
                                                            time: provider
                                                                .dateTime
                                                                .toString())
                                                        .then((value) => log(
                                                            "Task Deleted..."));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            );
                            }),
                          );
                        },
                      );
                    }
                  },
                );
              }),
            ),
          ),
          SizedBox(
            height: AdHelper.adHelper.bannerAd.size.height.toDouble(),
            width: double.infinity,
            child: AdWidget(
              ad: AdHelper.adHelper.bannerAd,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {
          Navigator.of(context).pushNamed('new_task_page');
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.black12,
    );
  }
}
