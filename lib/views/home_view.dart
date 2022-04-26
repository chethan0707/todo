import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:todo/entities/item.dart';
import 'package:todo/views/desc_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<TodoItem> taskList = [];

  Future<List<TodoItem>> fillItemList() async {
    return taskList = await getItems();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Todo",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/add/');
            },
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed('/signin/');
              },
              child: const Text(
                'Sign-out',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: FutureBuilder(
        future: fillItemList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (taskList.isEmpty) {
                return const Center(child: Text('No Todo items found'));
              } else {
                return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final item = taskList[index];
                    return Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(2),
                      height: 75,
                      child: TextButton(
                        child: Card(
                          elevation: 10,
                          margin: const EdgeInsets.only(left: 3, right: 3),
                          color: Colors.blueGrey.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "   " + item.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              Checkbox(
                                value: item.isDone,
                                onChanged: (value) async {
                                  var email =
                                      FirebaseAuth.instance.currentUser!.email;
                                  http.post(
                                    Uri.parse(
                                        "http://localhost:8080/todo/update"),
                                    body: json.encode({
                                      "item": {
                                        "_id": item.id,
                                        "title": item.title,
                                        "description": item.description,
                                        "isDone": !item.isDone
                                      },
                                      "email": email,
                                    }),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                  );
                                  taskList = await getItems();
                                  setState(() {});
                                },
                                activeColor: Colors.blueGrey.shade800,
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DescPage(item: item)),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<TodoItem>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/todo/items").replace(
        queryParameters: {"email": FirebaseAuth.instance.currentUser!.email},
      ),
    );
    var jsonBody = json.decode(response.body);
    var items =
        List<TodoItem>.from(jsonBody.map((model) => TodoItem.fromJson(model)));
    return items;
  }
}
