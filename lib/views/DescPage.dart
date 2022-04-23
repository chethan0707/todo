import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo/entities/item.dart';
import 'package:todo/views/UpdateView.dart';

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateView(item: widget.item)),
                  );
                },
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
