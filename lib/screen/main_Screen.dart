import 'package:bucketlist/screen/add_Screen.dart';
import 'package:bucketlist/screen/view_Screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<dynamic> BucketlistData = [];
  bool isLoading = false;
  bool isError = false;
  Future<void> getdata() async {
    // ignore: unused_local_variable
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://employeeform-b5e7e-default-rtdb.firebaseio.com/buketList.json");
      if (response.data is List) {
        BucketlistData = response.data;
      } else {
        BucketlistData = [];
      }

      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  Widget errorWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          size: 45,
        ),
        const SizedBox(height: 10),
        const Text("Error getting bucket list data",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                shadowColor: Colors.grey,
                backgroundColor: Colors.amber[100]),
            onPressed: getdata,
            child: const Text("Try Again"))
      ],
    ));
  }

  Widget listDataWidget() {
    // ignore: unused_local_variable
    List<dynamic> filterredList =
        BucketlistData.where((element) => !element["completed"]).toList();

    return filterredList.length < 1
        ? const Center(child: Text("No Data Bucket List"))
        : ListView.builder(
            itemCount: BucketlistData.length,
            itemBuilder: (BuildContext context, int index) {
              return (BucketlistData[index] is Map &&
                      (!BucketlistData[index]["completed"]))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItemScreen(
                                index: index,
                                title: BucketlistData[index]['items'] ?? '',
                                image: BucketlistData[index]['img'] ?? '');
                          })).then((value) {
                            getdata();
                          });
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(BucketlistData[index]?['img'] ?? ''),
                        ),
                        title: Text(
                          BucketlistData[index]?['items'] ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          BucketlistData[index]?['Cost'].toString() ?? "",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : const SizedBox();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddbucketlistState(newindex: BucketlistData.length);
            })).then((value) {
              if (value == "Refresh") {
                getdata();
              }
            });
          }),
      appBar: AppBar(
        title: const Text(
          "Bucket list",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: getdata,
              child: const Icon(
                Icons.refresh,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            getdata();
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : isError
                  ? errorWidget()
                  : listDataWidget()),
    );
  }
}
