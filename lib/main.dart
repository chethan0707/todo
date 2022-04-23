import 'package:flutter/material.dart';
import 'package:todo/views/AddView.dart';
import 'package:todo/views/HomeView.dart';

void main() {
  return runApp(MaterialApp(
    routes: {
      '/home/': (context) => const Home(),
      '/add/': (context) => const AddView(),
    },
    home: const Home(),
  ));
}
