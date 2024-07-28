import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddbucketlistState extends StatefulWidget {
  int newindex;
  AddbucketlistState({super.key, required this.newindex});

  @override
  State<AddbucketlistState> createState() => _AddbucketlistStateState();
}

class _AddbucketlistStateState extends State<AddbucketlistState> {
  TextEditingController ItemText = TextEditingController();
  TextEditingController CostText = TextEditingController();
  TextEditingController ImageUrl = TextEditingController();

  Future<void> AdddataList() async {
    Map<String, dynamic> data = {
      "Cost": CostText.text,
      "completed": false,
      "img": ImageUrl.text,
      "items": ItemText.text
    };
    try {
      // ignore: unused_local_variable
      Response response = await Dio().patch(
          "https://employeeform-b5e7e-default-rtdb.firebaseio.com/buketList/${widget.newindex}.json",
          data: data);
      Navigator.pop(context, "Refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.toString().length < 3) {
                      return "Item name must be 3 characters long";
                    }
                    if (value == null || value.isEmpty) {
                      return "This must be not Empty";
                    }
                  },
                  controller: ItemText,
                  decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    label: Text("Items"),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Item name must be 3 characters long";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must be not Empty";
                  }
                },
                controller: CostText,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  label: Text("Estimated Cost"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Item name must be 3 characters long";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must be not Empty";
                  }
                },
                controller: ImageUrl,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  label: Text("Images URL"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      if (addForm.currentState!.validate()) {
                        AdddataList();
                      }
                    },
                    child: const Text(
                      "Add Items",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[400]),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
