import 'package:flutter/material.dart';
import 'package:todo/views/add_view.dart';
import 'package:todo/views/home_view.dart';

void main() {
  return runApp(MaterialApp(
    routes: {
      '/home/': (context) => const Home(),
      '/add/': (context) => const AddView(),
    },
    home: const Home(),
  ));
}
