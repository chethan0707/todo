import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo/entities/item.dart';

class UpdateView extends StatefulWidget {
  final TodoItem item;
  const UpdateView({Key? key, required this.item}) : super(key: key);
  @override
  State<UpdateView> createState() => _UpdateView();
}

class _UpdateView extends State<UpdateView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late String title, description;
  @override
  void initState() {
    _descController.text = widget.item.description;

    _descController.addListener(() {
      description = _descController.text;
    });
    _titleController.text = widget.item.title;

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
                          id: widget.item.id,
                          title: _titleController.text,
                          description: _descController.text,
                          isDone: widget.item.isDone);
                      final response = await http.post(
                        Uri.parse("http://localhost:8080/todo/update"),
                        body: jsonEncode({
                          "item": item.toJson(),
                          "email": FirebaseAuth.instance.currentUser!.email
                        }),
                        headers: {'Content-Type': 'application/json'},
                        encoding: Encoding.getByName('utf-8'),
                      );
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Updated item')));
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
