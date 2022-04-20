import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/entities/item.dart';

void main() {
  return runApp(const Home());
}

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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              onPressed: () async {},
            ),
          ],
        ),
        body: FutureBuilder(
          future: fillItemList(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final item = taskList[index];
                    return Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(2),
                      height: 75,
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Checkbox(
                              value: item.isDone,
                              onChanged: (value) {
                                value = log(item.isDone.toString());
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<TodoItem>> getItems() async {
    final response =
        await http.get(Uri.parse("http://localhost:8080/todo/items"));
    var jsonBody = json.decode(response.body);
    var items =
        List<TodoItem>.from(jsonBody.map((model) => TodoItem.fromJson(model)));
    return items;
  }
}
