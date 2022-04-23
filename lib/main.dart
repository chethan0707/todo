import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/entities/item.dart';

void main() {
  return runApp(MaterialApp(
    routes: {
      '/home/': (context) => const Home(),
      '/add/': (context) => const AddView(),
    },
    home: const Home(),
  ));
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
                                  http.post(
                                    Uri.parse(
                                        "http://localhost:8080/todo/update"),
                                    body: json.encode({
                                      "title": item.title,
                                      "description": item.description,
                                      "isDone": !item.isDone
                                    }),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    encoding: Encoding.getByName('utf-8'),
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
              return const CircularProgressIndicator();
          }
        },
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

class AddView extends StatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  var title, description;
  @override
  void initState() {
    _descController.addListener(() {
      description = _descController.text;
    });
    _titleController.addListener(() {
      title = _titleController.text;
      log(title.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade400,
      appBar: AppBar(
        title: const Text(
          'Add new task',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 1,
              maxLength: 30,
              controller: _titleController,
              decoration: const InputDecoration(
                label: Text(
                  'Title',
                  style: TextStyle(color: Colors.black),
                ),
                hintText: 'Enter Title',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                label: Text(
                  'Description',
                  style: TextStyle(color: Colors.black),
                ),
                hintText: 'Enter Description',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              maxLines: null,
              cursorColor: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Title cannot be empty')));
                    } else {
                      final item = TodoItem(
                          id: "",
                          title: title,
                          description: description,
                          isDone: false);
                      final response = await http.post(
                        Uri.parse("http://localhost:8080/todo/add"),
                        body: jsonEncode(item.toJson()),
                        headers: {'Content-Type': 'application/json'},
                        encoding: Encoding.getByName('utf-8'),
                      );
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Successfully created Todo Item')));
                        setState(() {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/home/', (_) => false);
                        });
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 90,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.black),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade700,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DescPage extends StatefulWidget {
  final TodoItem item;

  const DescPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DescPage> createState() => _DescPageState();
}

class _DescPageState extends State<DescPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade400,
      appBar: AppBar(
        title: Text(
          widget.item.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(4),
            height: 200,
            width: 400,
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.only(left: 3, right: 3),
              color: Colors.blueGrey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(widget.item.description)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Icon(
                  Icons.edit,
                  color: Colors.blueGrey.shade900,
                ),
                onPressed: () {},
              ),
              TextButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.blueGrey.shade900,
                ),
                onPressed: () async {
                  final response = await http.delete(
                    Uri.parse("http://localhost:8080/todo/delete")
                        .replace(queryParameters: {"_id": widget.item.id}),
                  );
                  Navigator.pop(context);
                  log(widget.item.id.toString());
                  log(response.statusCode.toString());
                  log(response.body.toString());
                  setState(() {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home/', (_) => false);
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
