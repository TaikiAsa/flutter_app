import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/rendering.dart';

import 'header.dart';
import 'root.dart';

void main() {
  initializeApp(
      apiKey: "AIzaSyBJkqNXfLWEFbHNiuXSVh0-icxmThDhNKc",
      authDomain: "flutterapp-10ae8.firebaseapp.com",
      databaseURL: "https://flutterapp-10ae8.firebaseio.com",
      projectId: "flutterapp-10ae8",
      storageBucket: "flutterapp-10ae8.appspot.com");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firestore memo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootWidget(), //new MyList(),
    );
  }
}

