import 'dart:convert';

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
  @override
  void initState() {
    super.initState();
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
              onPressed: () async {
                taskList = await getItems();
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            final item = taskList[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: Checkbox(
                value: item.isDone,
                onChanged: (bool? value) async {
                  http.post(
                    Uri.parse("http://localhost:8080/todo/update"),
                    body: json.encode({
                      "title": item.title,
                      "description": item.description,
                      "isDone": !item.isDone
                    }),
                    headers: {'Content-Type': 'application/json'},
                    encoding: Encoding.getByName('utf-8'),
                  );
                  taskList = await getItems();
                  setState(() {});
                },
              ),
            );
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
