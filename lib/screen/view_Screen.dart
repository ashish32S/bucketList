import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewItemScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.index});

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      // ignore: unused_local_variable
      Response response = await Dio().delete(
          "https://employeeform-b5e7e-default-rtdb.firebaseio.com/buketList/${widget.index}.json");
      Navigator.pop(context);
    } catch (e) {
      print("error");
    }
  }

  Future<void> markasCompleted() async {
    Map<String, dynamic> data = {"completed": true};
    try {
      // ignore: unused_local_variable
      Response response = await Dio().patch(
          "https://employeeform-b5e7e-default-rtdb.firebaseio.com/buketList/${widget.index}.json",
          data: data);
      Navigator.pop(context, "Refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 1) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are You Sure Delete Item"),
                      actions: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        InkWell(
                            onTap: () {
                              deleteData();
                            },
                            child: Text("Confirm"))
                      ],
                    );
                  });
            }
            if (value == 2) {
              markasCompleted();
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 1, child: Text("Delete")),
              const PopupMenuItem(value: 2, child: Text("Mark as read"))
            ];
          })
        ],
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.red[100],
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(widget.image))),
          ),
        ],
      ),
    );
  }
}
